//
//  DeleteUser.swift
//  Model
//
//  Created by 서원지 on 8/4/24.
//

import Foundation

public struct DeleteUserModel: Equatable, Codable {
    public let data: DeleteUserModelResponse?
    
    public init(
        data: DeleteUserModelResponse? = nil
    ) {
        self.data = data
    }
}

public struct DeleteUserModelResponse: Codable, Equatable {
    public let status: Bool?
    public let message: String?
    
    public init(status: Bool?, message: String?) {
        self.status = status
        self.message = message
    }
}

