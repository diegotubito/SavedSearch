//
//  SavedSearchFilterViewReskin.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 04/11/2023.
//

import SwiftUI

struct FilterExclusionCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewmodel: SavedSearchViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewmodel.getFilterExclusionCategories(), id: \.self) { item in
                        NavigationLink {
                            FilterExlusionOptionView(viewmodel: viewmodel, filterExclusionOptionViewModel: FilterExlusionOptionViewModel(selectedItem: item))
                        } label: {
                            SavedSearchViewCell(title: item.display, subtitle: "", counter: viewmodel.getCount(item))
                        }
                    }
                }
            }
            Spacer()
            footerView()
        }
        .padding()
        .navigationTitle("Create Saved Search")
    }
    
    func footerView() -> some View {
        return VStack {
            Button("SAVE EXCLUSIONS") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    FilterExclusionCategoryView(viewmodel: SavedSearchViewModel(savedFilterExclusions: []))
}
