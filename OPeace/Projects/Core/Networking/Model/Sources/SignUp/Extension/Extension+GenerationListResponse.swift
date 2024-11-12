//
//  Extension+GenerationListResponse.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public extension GenerationListResponse {
  func toGenerationListDTOToModel() -> SignUpListDTOModel {
    let data: SignUpListResponseDTOModel = .init(content: self.data?.data ?? [])
    return SignUpListDTOModel(data: data)
  }
}
