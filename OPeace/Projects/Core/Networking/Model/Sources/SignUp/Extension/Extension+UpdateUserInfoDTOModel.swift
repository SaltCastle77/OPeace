//
//  Extension+UpdateUserInfoDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

public extension UpdateUserInfoModel {
  func toUpdateUserInfoDTOToModel() -> UpdateUserInfoDTOModel {
    let data: UpdateUserInfoResponseDTOModel = .init(
      socialID: self.data?.socialID ?? "",
      socialType: self.data?.socialType ?? "",
      email: self.data?.email ?? "",
      createdAt: self.data?.createdAt ?? "",
      nickname: self.data?.nickname,
      year: self.data?.year ,
      job: self.data?.job,
      generation: self.data?.generation ?? "",
      isFirstLogin: self.data?.isFirstLogin ?? false
    )
    
    return UpdateUserInfoDTOModel(data: data)
  }
}

public extension UpdateUserInfoDTOModel {
  static var mockModel: UpdateUserInfoDTOModel = UpdateUserInfoDTOModel(
    data: UpdateUserInfoResponseDTOModel(
      socialID: "apple_001096.cf7680b2761f4de694a1d1c21ea507a6.1112",
      socialType: "apple",
      email: "shuwj81@daum.net",
      createdAt: "2024-08-29 01:39:57",
      nickname: "오피스",
      year: 1998,
      job: "개발",
      generation: "Z 세대",
      isFirstLogin: true
    )
  )
}
