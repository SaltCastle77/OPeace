//
//  Extension+UserBlockListModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

import Foundation

public extension UserBlockListModel {
  func toUserBlockLIstDTOToModel() -> UserBlockListDTOModel {
    let data: [UserBlockListResponseDTOModel] = self.data?.compactMap(
      { data in
        return UserBlockListResponseDTOModel(
          blockID: data.blockID ?? .zero,
          blockedUserID: data.blockedUserID ?? "",
          nickname: data.nickname ?? "",
          job: data.job ?? "",
          generation: data.generation ?? ""
        )
    }) ?? []
    
    return UserBlockListDTOModel(data: data)
  }
}
