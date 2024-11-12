//
//  UserBlockModel.swift
//  Model
//
//  Created by 서원지 on 8/25/24.
//

// MARK: - Welcome
import Foundation

public struct UserBlockModel: Codable, Equatable {
    public let data: UserBlockResponseModel?
    
    public init(
        data: UserBlockResponseModel?
    ) {
        self.data = data
    }
}

// MARK: - DataClass
public struct UserBlockResponseModel: Codable, Equatable {
    public let status: Bool?
    public let message: String?
    
    public init(
        status: Bool?,
        message: String?
    ) {
        self.status = status
        self.message = message
    }
}
