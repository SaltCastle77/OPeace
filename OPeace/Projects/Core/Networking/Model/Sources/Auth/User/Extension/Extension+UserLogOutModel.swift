//
//  Extension+UserLogOutModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

import Foundation

public extension UserLogOutModel {
  func toUserDTOToModel() -> UserDTOModel {
    let data: UserResponseDTOModel = .init(
      job: self.data?.job ?? "",
      generation: self.data?.generation ?? "",
      nickname: self.data?.nickname ?? "",
      email: self.data?.email ?? "",
      isFirstLogin: self.data?.isFirstLogin ?? false,
      year: self.data?.year ?? .zero
    )
    return UserDTOModel(data: data)
  }
}
