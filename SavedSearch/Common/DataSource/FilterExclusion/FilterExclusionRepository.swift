//
//  FilterExclusionRepository.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 05/11/2023.
//

import Foundation

typealias FilterExclusionResult = (Result<Data, APIError>) -> Void

protocol FilterExclusionRepositoryProtocol {
    func getFilterOptions(completion: @escaping FilterExclusionResult)
}

class FilterExclusionRepository: ApiNetworkMock, FilterExclusionRepositoryProtocol {
    func getFilterOptions(completion: @escaping FilterExclusionResult) {
        mockFileName = "filter_exclusion_options_response"
        apiCallMocked(bundle: .main) { result in
            completion(result)
        }
    }
}
