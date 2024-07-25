//
//  EmptyModel.swift
//  Model
//
//  Created by 서원지 on 7/23/24.
//

public struct EmptyModel: Codable, Equatable {
    public var code: String?
    
    public init(
        code: String? = nil
    ) {
        self.code = code
    }
}
