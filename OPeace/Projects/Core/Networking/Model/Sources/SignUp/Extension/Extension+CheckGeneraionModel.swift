//
//  Extension+CheckGeneraionModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public extension CheckGeneraionModel {
  func toSignUpInfoDTOToModel() -> SignUpCheckInfoDTOModel {
    let data: SignUpCheckInfoResponseDTOModel = .init(
      message: self.data?.data ?? "" ,
      exists: false
    )
    return SignUpCheckInfoDTOModel(data: data)
  }
}
