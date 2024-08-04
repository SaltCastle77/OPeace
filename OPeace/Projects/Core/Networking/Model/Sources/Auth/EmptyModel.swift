//
//  EmptyModel.swift
//  Model
//
//  Created by 서원지 on 7/23/24.
//

public struct EmptyModel: Codable, Equatable {
    public let detail, code: String?
    
    public init(detail: String?, code: String?) {
        self.detail = detail
        self.code = code
    }
}
