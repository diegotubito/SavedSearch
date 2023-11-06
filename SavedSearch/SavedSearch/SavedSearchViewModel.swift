//
//  SavedSearchViewModel.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 05/11/2023.
//

import Foundation

struct SavedFilterExclusionModel: Codable {
    let filterType: String
    let value: Bool
    
    enum CodingKeys: String,  CodingKey {
        case filterType = "filter_type"
        case value
    }
}

class SavedSearchViewModel: ObservableObject {
    var savedFilterExclusions: [SavedFilterExclusionModel]?
    
    init(savedFilterExclusions: [SavedFilterExclusionModel]?) {
        self.savedFilterExclusions = savedFilterExclusions
    }
    
    private var filterExclusionCategories: [FilterExclusionCategory] = []
    private var responseData: Data?
        
    func getFilterExclusionCategories() -> [FilterExclusionCategory] {
        return filterExclusionCategories
    }
    
    func getFilterExclusionOptions() {
        let repository = FilterExclusionRepository()
        repository.getFilterOptions { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.responseData = response
                    self.mapFilterExclusion()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func mapFilterExclusion() {
        guard let responseData = responseData, let dictionary = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
              let data = dictionary["data"] as? [String: Any] else { return }
        
        filterExclusionCategories.removeAll()

        for (typeKey, typeValue) in data {
            if let typeDict = typeValue as? [String: Any],
               let display = typeDict["display"] as? String,
               let optionsArray = typeDict["options"] as? [[String: Any]] {
                
                let options: [FilterExclusionCategory.Option] = optionsArray.compactMap { optionDict in
                    guard let display = optionDict["display"] as? String,
                          let value = optionDict["value"] as? String,
                          let risky = optionDict["risky"] as? Bool else {
                        return nil
                    }
                    //The mapping is constructed with the right selected value if
                    let isSelected = savedFilterExclusions?.contains(where: {$0.filterType == value}) ?? false
                    return FilterExclusionCategory.Option(display: display, value: value, risky: risky, isSelected: isSelected)
                }
                
                // Remove "Exclusion: " from the display string
                let modifiedDisplay = display.replacingOccurrences(of: "Exclusion: ", with: "")

                let category = FilterExclusionCategory(type: typeKey, display: modifiedDisplay, options: options)
                filterExclusionCategories.append(category)
            }
        }
    }
    
    func clearAllSelection() {
        savedFilterExclusions?.removeAll()
        mapFilterExclusion()
    }
}
