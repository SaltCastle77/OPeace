//
//  SettingProfile.swift
//  Model
//
//  Created by 서원지 on 8/3/24.
//

public enum SettingProfile: String, CaseIterable , Equatable{
    case editProfile
    case blackManagement
    case contactUs
    case logout
    case withDraw
    
    
    public var desc: String {
        switch self {
        case .editProfile:
            return "내 정보 수정"
        case .blackManagement:
            return "차단 관리 "
        case .contactUs:
          return "문의하기"
        case .logout:
            return "로그아웃"
        case .withDraw:
            return "회원탈퇴"
        }
    }
}
