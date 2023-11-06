//
//  FilterExclusionModel.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 05/11/2023.
//

struct FilterExclusionCategory: Codable {
    let type: String
    let display: String
    let options: [Option]
    
    struct Option: Codable {
        let display: String
        let value: String
        let risky: Bool
        var isSelected: Bool = false
    }
}


