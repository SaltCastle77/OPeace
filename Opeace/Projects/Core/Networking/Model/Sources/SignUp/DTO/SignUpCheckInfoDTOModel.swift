//
//  SignUpCheckInfoDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public struct SignUpCheckInfoDTOModel: Codable , Equatable {
  public let data: SignUpCheckInfoResponseDTOModel
  
  public init(
    data: SignUpCheckInfoResponseDTOModel
  ) {
    self.data = data
  }
}

public struct SignUpCheckInfoResponseDTOModel: Codable, Equatable {
  public let message: String
  public let exists: Bool
  
  public init(
    message: String,
    exists: Bool
  ) {
    self.message = message
    self.exists = exists
  }
}
