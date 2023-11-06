//
//  FilterExlusionOptionViewModel.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 06/11/2023.
//

import Foundation

class FilterExlusionOptionViewModel: ObservableObject {
    @Published var selectedItem: FilterExclusionCategoryModel
    
    init(selectedItem: FilterExclusionCategoryModel) {
        self.selectedItem = selectedItem
    }
    
    func toggleIsSelected(option: FilterExclusionCategoryModel.Option) {
        if let index = selectedItem.options.firstIndex(where: { $0.id == option.id }) {
            selectedItem.options[index].isSelected.toggle()
        }
    }
}
