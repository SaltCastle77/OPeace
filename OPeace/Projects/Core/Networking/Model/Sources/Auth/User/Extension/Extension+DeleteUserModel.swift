//
//  Extension+DeleteUserModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

public extension DeleteUserModel {
  func toDeleteUserDTOToModel() -> DeletUserDTOModel {
    let data: DeletUserResponseDTOModel = .init(
      status: self.data?.status ?? false,
      message: self.data?.message ?? ""
    )
    return DeletUserDTOModel(data: data)
  }
}
