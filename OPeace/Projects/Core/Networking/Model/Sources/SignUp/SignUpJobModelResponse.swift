//
//  SignUpJobModel.swift
//  Model
//
//  Created by 서원지 on 7/27/24.
//

public struct SignUpJobModel: Codable, Equatable {
    public let data: SignUpJobModelResponse?
    
    public init(data: SignUpJobModelResponse?) {
        self.data = data
    }
}

public struct SignUpJobModelResponse: Codable, Equatable {
    public let data: [String]?
    
    public init(data: [String]?) {
        self.data = data
        
    }
    public enum Component: String, Codable {
        case data
    }
}


