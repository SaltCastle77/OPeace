//
//  SignUpGeneraion.swift
//  Model
//
//  Created by 서원지 on 8/28/24.
//
import Foundation

// MARK: - Welcome
public struct CheckGeneraionModel: Decodable {
     let data: CheckGeneraionResponseModel?
    
}

// MARK: - DataClass
struct CheckGeneraionResponseModel: Decodable {
     let data: String?
    
}
