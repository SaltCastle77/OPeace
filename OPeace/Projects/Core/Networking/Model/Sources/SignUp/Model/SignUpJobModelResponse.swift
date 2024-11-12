//
//  SignUpJobModel.swift
//  Model
//
//  Created by 서원지 on 7/27/24.
//

public struct SignUpJobModel: Decodable {
     let data: SignUpJobModelResponse?
    
}

struct SignUpJobModelResponse: Decodable {
     let data: [String]?
    
     enum Component: String, Codable {
        case data
    }
}


