//
//  SavedSearchViewModel.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 05/11/2023.
//

import SwiftUI

struct SavedFilterExclusionModel: Codable {
    let filterType: String
    let value: Bool
    
    enum CodingKeys: String,  CodingKey {
        case filterType = "filter_type"
        case value
    }
}

class SavedSearchViewModel: ObservableObject {
    var savedFilterExclusions: [SavedFilterExclusionModel]
    
    init(savedFilterExclusions: [SavedFilterExclusionModel] = []) {
        self.savedFilterExclusions = savedFilterExclusions
    }
    
    private var filterExclusionCategories: [FilterExclusionCategoryModel] = []
    private var filterExclusionResponseData: Data?
    
    func getFilterExclusionCategories() -> [FilterExclusionCategoryModel] {
        return filterExclusionCategories
    }
    
    func getFilterExclusionOptions() {
        let repository = FilterExclusionRepository()
        repository.getFilterOptions { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.filterExclusionResponseData = response
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
        guard let responseData = filterExclusionResponseData, let dictionary = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
              let data = dictionary["data"] as? [String: Any] else { return }
        
        filterExclusionCategories.removeAll()

        for (typeKey, typeValue) in data {
            if let typeDict = typeValue as? [String: Any],
               let display = typeDict["display"] as? String,
               let optionsArray = typeDict["options"] as? [[String: Any]] {
                
                let options: [FilterExclusionCategoryModel.Option] = optionsArray.compactMap { optionDict in
                    guard let display = optionDict["display"] as? String,
                          let value = optionDict["value"] as? String,
                          let risky = optionDict["risky"] as? Bool else {
                        return nil
                    }
                    //The mapping is constructed with the right selected value if
                    let isSelected = savedFilterExclusions.contains(where: {$0.filterType == value}) ?? false
                    return FilterExclusionCategoryModel.Option(display: display, value: value, risky: risky, isSelected: isSelected)
                }
                
                // Sort options alphabetically by their 'display' property
                let sortedOptions = options.sorted { $0.display.localizedCaseInsensitiveCompare($1.display) == .orderedAscending }
                
                // Remove "Exclusion: " from the display string
                let modifiedDisplay = display.replacingOccurrences(of: "Exclusion: ", with: "")
                
                let category = FilterExclusionCategoryModel(type: typeKey, display: modifiedDisplay, options: sortedOptions)
                filterExclusionCategories.append(category)
            }
        }
        
        // Sort options alphabetically by their 'type' property
        filterExclusionCategories = filterExclusionCategories.sorted { $0.type.localizedCaseInsensitiveCompare($1.type) == .orderedAscending }
    }
    
    func clearAllSelection() {
        savedFilterExclusions.removeAll()
        mapFilterExclusion()
    }
    
    func getCount(_ item: FilterExclusionCategoryModel) -> Int {
        let counter = item.options.filter { $0.isSelected == true }.count
        if counter == item.options.count { return -1 }
        return counter
    }
    
    func selectItem(filterType: String) {
        let newSelection = SavedFilterExclusionModel(filterType: filterType, value: true)
        savedFilterExclusions.append(newSelection)
        // After updating the exclusions, re-map the categories to update their selected state
        mapFilterExclusion()
    }

    func deselectItem(filterType: String) {
        savedFilterExclusions.removeAll { $0.filterType == filterType }
        // After updating the exclusions, re-map the categories to update their selected state
        mapFilterExclusion()
    }
}
