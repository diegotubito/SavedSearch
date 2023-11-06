//
//  SavedSearchView.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 05/11/2023.
//

import SwiftUI

struct SavedSearchView: View {
    @StateObject var viewmodel: SavedSearchViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Button("Remove All Selection") {
                viewmodel.clearAllSelection()
                presentationMode.wrappedValue.dismiss()
            }
            
            NavigationLink {
                FilterExclusionOptions()
            } label: {
                Text("Exclusion Filters")
            }
        }
        .onAppear {
            viewmodel.getFilterExclusionOptions()
        }
    }
}

#Preview {
    SavedSearchView(viewmodel: SavedSearchViewModel(savedFilterExclusions: []))
}

