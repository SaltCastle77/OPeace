//
//  UserInfo.swift
//  Model
//
//  Created by 서원지 on 10/1/24.
//

import Foundation

public struct UserInfoModel: Equatable {
    public var isLogOut: Bool
    public var isDeleteUser: Bool
    public var isLookAround: Bool
    public var isChangeProfile: Bool
    public var isCreateQuestion: Bool
    public var isDeleteQuestion: Bool
    public var isReportQuestion: Bool 
    public var loginSocialType: SocialType?
    
    public init(
        isLogOut: Bool = false,
        isDeleteUser: Bool = false,
        isLookAround: Bool = false,
        isChangeProfile: Bool = false,
        isCreateQuestion: Bool = false,
        isDeleteQuestion: Bool = false,
        isReportQuestion: Bool = false,
        loginSocialType: SocialType? = nil
    ) {
        self.isLogOut = isLogOut
        self.isDeleteUser = isDeleteUser
        self.isLookAround = isLookAround
        self.isChangeProfile = isChangeProfile
        self.isCreateQuestion = isCreateQuestion
        self.isDeleteQuestion = isDeleteQuestion
        self.isReportQuestion = isReportQuestion
        self.loginSocialType = loginSocialType
    }
    
}
