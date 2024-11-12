//
//  Extension+RefreshModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

public extension RefreshModel {
  func toRefreshDTOToModel() -> RefreshDTOModel {
    let data: RefreshResponseDTOModel = .init(
      accessToken: self.data?.accessToken ?? "",
      refreshToken: self.data?.refreshToken ?? "")
    
    return RefreshDTOModel(data: data)
    
  }
}
