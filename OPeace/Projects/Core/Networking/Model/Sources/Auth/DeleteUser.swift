//
//  DeleteUser.swift
//  Model
//
//  Created by 서원지 on 8/4/24.
//

import Foundation

public struct DeleteUserModel: Equatable, Codable {
    public let data: EmptyModel?
    
    public init(
        data: EmptyModel? = nil
    ) {
        self.data = data
    }
}
