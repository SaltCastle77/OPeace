//
//  DeleteQuestionModel.swift
//  Model
//
//  Created by 서원지 on 8/26/24.
//

import Foundation

public struct DeleteQuestionModel: Decodable {
     let data: DeleteQuestionResponseModel?
    
}

// MARK: - DataClass
struct DeleteQuestionResponseModel: Decodable {
     let status: Bool?
     let message: String?
    
}
