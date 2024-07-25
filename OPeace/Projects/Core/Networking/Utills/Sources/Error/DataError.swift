//
//  DataError.swift
//  Utills
//
//  Created by 서원지 on 7/21/24.
//

import Foundation
import Moya

public enum DataError: Error {
    case error(Error)
    case emptyValue
    case invalidatedType
    case decodingError(Error)
    case statusCodeError(Int)
    case noData
    case badRequest
    case unhandledStatusCode(Int)
    case errorData(String)
    case moyaError(MoyaError)
    case unknownError
    
}
