//
//  ErrorResponse.swift
//  Utills
//
//  Created by 서원지 on 8/5/24.
//
import Foundation

public struct ErrorResponse: Decodable {
    let detail: String
    let code: String
    
    public init(detail: String, code: String) {
        self.detail = detail
        self.code = code
    }
}
