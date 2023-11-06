//
//  FilterExclusionEntity.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 05/11/2023.
//

import Foundation

struct FilterExclusionEntity {
    struct Response: Decodable {
        let data: [FilterExclusionCategory]
    }
}
