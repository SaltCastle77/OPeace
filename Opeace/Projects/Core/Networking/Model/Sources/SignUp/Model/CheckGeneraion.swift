//
//  SignUpGeneraion.swift
//  Model
//
//  Created by 서원지 on 8/28/24.
//
import Foundation

// MARK: - Welcome
public struct CheckGeneraionModel: Codable, Equatable {
    public let data: CheckGeneraionResponseModel?
    
    public init(
        data: CheckGeneraionResponseModel?
    ) {
        self.data = data
    }
}

// MARK: - DataClass
public struct CheckGeneraionResponseModel: Codable, Equatable {
    public let data: String?
    
    public init(
        data: String?
    ) {
        self.data = data
    }
}
