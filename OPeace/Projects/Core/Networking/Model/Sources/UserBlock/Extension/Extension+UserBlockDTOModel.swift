//
//  Extension+UserBlockDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

public extension UserBlockModel {
  func toUserBlockDTOToModel() -> UserBlockDTOModel {
    let data: UserBlockResponseDTOModel = .init(
      status: self.data?.status ?? false,
      message: self.data?.message ?? ""
    )
    
    return UserBlockDTOModel(data: data)
  }
 
}
