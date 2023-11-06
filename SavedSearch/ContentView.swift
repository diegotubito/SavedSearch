//
//  ContentView.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 04/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var savedSearchViewModel = SavedSearchViewModel(savedFilterExclusions: [SavedFilterExclusionModel(filterType: "cr__minor_body_damage", value: true)])

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    SavedSearchView(viewmodel: savedSearchViewModel)
                } label: {
                    Text("go to Saved Serach")
                }
                
            }
            .onAppear {
                if savedSearchViewModel.savedFilterExclusions.isEmpty {
                    print("is empty")
                } else {
                    for i in savedSearchViewModel.savedFilterExclusions {
                        print(i.filterType, i.value)
                    }
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
