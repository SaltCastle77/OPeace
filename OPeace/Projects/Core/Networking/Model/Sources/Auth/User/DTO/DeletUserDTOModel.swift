//
//  DeletUserDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//
import Foundation

public struct DeletUserDTOModel: Codable, Equatable {
  public let data: DeletUserResponseDTOModel
  
  public init(
    data: DeletUserResponseDTOModel
  ) {
    self.data = data
  }
}

public struct DeletUserResponseDTOModel: Codable, Equatable {
  public let status: Bool
  public let message: String
  
  public init(
    status: Bool,
    message: String
  ) {
    self.status = status
    self.message = message
  }
}
