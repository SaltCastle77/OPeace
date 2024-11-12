//
//  CheckNickName.swift
//  Model
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

public struct CheckNickNameModel: Decodable {
     var data: CheckNickNameResponse?
    
}


struct CheckNickNameResponse: Decodable {
     var exists: Bool?
     var message: String?
    
     enum CodingKeys: String, CodingKey {
        case exists, message
    }
}
