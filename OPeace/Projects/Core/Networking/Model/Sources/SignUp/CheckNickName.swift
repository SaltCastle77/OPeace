//
//  CheckNickName.swift
//  Model
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

public struct CheckNickName: Codable, Equatable {
    public var exists: Bool?
    public var message: String?
    
    public enum CodingKeys: String, CodingKey {
        case exists, message
    }
    
    public init(
        exists: Bool?,
        message: String?
    ) {
        self.exists = exists
        self.message = message
    }
}
