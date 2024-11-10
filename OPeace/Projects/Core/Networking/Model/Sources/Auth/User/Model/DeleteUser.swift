//
//  DeleteUser.swift
//  Model
//
//  Created by 서원지 on 8/4/24.
//

import Foundation

public struct DeleteUserModel: Decodable {
     let data: DeleteUserModelResponse?
    
    
}

struct DeleteUserModelResponse: Decodable {
     let status: Bool?
     let message: String?
  
}

