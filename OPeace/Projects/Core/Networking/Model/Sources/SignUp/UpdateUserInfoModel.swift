//
//  UpdateUserInfoModel.swift
//  Model
//
//  Created by 서원지 on 7/30/24.
//

import Foundation

// MARK: - Welcome
public struct UpdateUserInfoModel: Codable, Equatable {
    public let data: UpdateUserInfoResponse?
    
    public init(data: UpdateUserInfoResponse?) {
        self.data = data
    }
    
}

// MARK: - DataClass
public struct UpdateUserInfoResponse: Codable, Equatable {
    let nickname, year, generation, job: Generation?
    
    public enum CodingKeys: String, CodingKey {
        case nickname
        case year
        case generation
        case job
    }
    
    public init(
        nickname: Generation?,
        year: Generation?,
        generation: Generation?,
        job: Generation?
    ) {
        self.nickname = nickname
        self.year = year
        self.generation = generation
        self.job = job
    }
}

// MARK: - Generation
public struct Generation: Codable , Equatable{
    let message: String?
    
    public init(message: String?) {
        self.message = message
    }
    
    public enum CodingKeys: String, CodingKey {
        case message
    }
}
