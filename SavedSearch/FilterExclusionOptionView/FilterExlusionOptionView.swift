//
//  FilterExlusionOptionView.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 06/11/2023.
//

import SwiftUI

struct FilterExlusionOptionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewmodel: SavedSearchViewModel
    @StateObject var filterExclusionOptionViewModel: FilterExlusionOptionViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(filterExclusionOptionViewModel.selectedItem.options, id: \.self) { option in
                    HStack {
                        if option.isSelected {
                            Image(systemName: "checkmark.square.fill")
                        } else {
                            Image(systemName: "square")
                        }
                        Text(option.display)
                        Spacer()
                    }
                    .padding()
                    .onTapGesture {
                        if option.isSelected {
                            viewmodel.deselectItem(filterType: option.value)
                        } else {
                            viewmodel.selectItem(filterType: option.value)
                        }
                        filterExclusionOptionViewModel.toggleIsSelected(option: option)
                    }
                    Divider()
                }
            }
            .padding()
            footerView()
        }
        .navigationTitle(filterExclusionOptionViewModel.selectedItem.display)
    }
    
    func footerView() -> some View {
        return VStack {
            Button("DONE") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    FilterExlusionOptionView(viewmodel: SavedSearchViewModel(savedFilterExclusions: []), filterExclusionOptionViewModel: FilterExlusionOptionViewModel(selectedItem: FilterExclusionCategoryModel(id: nil, type: "", display: "", options: [])))
}
