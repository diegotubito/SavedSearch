//
//  ContentView.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 04/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    var savedFilterExclusions = [SavedFilterExclusionModel(filterType: "cr__minor_body_damage", value: true)]

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    SavedSearchView(viewmodel: SavedSearchViewModel(savedFilterExclusions: savedFilterExclusions))
                } label: {
                    Text("go to Saved Serach")
                }
                
            }
            .onAppear {
                if savedFilterExclusions.isEmpty {
                    print("is empty")
                } else {
                    for i in savedFilterExclusions {
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
