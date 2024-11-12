//
//  Extension+CheckUserVerifyModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

public extension CheckUserVerifyModel {
  func toCheckUserDTOModel() -> CheckUserDTOModel {
    let data: CheckUserDTOResponseModel = .init(
      job: self.data?.user?.job ?? "",
      generation: self.data?.user?.generation ?? "",
      nickname: self.data?.user?.nickname ?? "",
      email: self.data?.user?.email ?? "",
      isFirstLogin: self.data?.user?.isFirstLogin ?? false,
      year: self.data?.user?.year ?? .zero,
      status: self.data?.status ?? false
    )
    
    return CheckUserDTOModel(data: data)
  }
  
}
