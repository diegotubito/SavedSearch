//
//  FilterExclusionModel.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 05/11/2023.
//

import SwiftUI

struct FilterExclusionCategoryModel: Codable, Identifiable, Hashable {
    var id: UUID? = UUID()
    let type: String
    let display: String
    var options: [Option]
    
    struct Option: Codable, Identifiable, Hashable {
        var id: UUID? = UUID()
        let display: String
        let value: String
        let risky: Bool
        var isSelected: Bool = false
    }
}


