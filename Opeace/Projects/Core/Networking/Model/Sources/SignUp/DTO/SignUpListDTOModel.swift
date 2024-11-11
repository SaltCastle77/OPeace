//
//  SignUpListDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public struct SignUpListDTOModel: Codable, Equatable {
  public let data: SignUpListResponseDTOModel
  
  public init(
    data: SignUpListResponseDTOModel
  ) {
    self.data = data
  }
}


public struct SignUpListResponseDTOModel: Codable, Equatable {
  public let content: [String]
  
  public init(
    content: [String]
  ) {
    self.content = content
  }
}
