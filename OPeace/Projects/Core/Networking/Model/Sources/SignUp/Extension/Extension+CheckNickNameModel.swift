//
//  Extension+CheckNickNameModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//
import Foundation

public extension CheckNickNameModel {
  func toSignUPInfoDTOToModel() -> SignUpCheckInfoDTOModel {
    let data: SignUpCheckInfoResponseDTOModel = .init(
      message: self.data?.message ?? "",
      exists: self.data?.exists ?? false
    )
    
    return SignUpCheckInfoDTOModel(data: data)
  }
}
