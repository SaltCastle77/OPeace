//
//  UserLogOut.swift
//  Model
//
//  Created by 서원지 on 8/3/24.
//

import Foundation

public struct UserLogOut: Equatable, Codable {
    public let data: EmptyModel?
    
    public init(
        data: EmptyModel?
    ) {
        self.data = data
    }
}
