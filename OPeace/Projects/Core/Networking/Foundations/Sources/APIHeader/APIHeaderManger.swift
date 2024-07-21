//
//  APIHeaderManger.swift
//  Foundations
//
//  Created by 서원지 on 7/18/24.
//

import Foundation

public class APIHeaderManger {
    public static let shared = APIHeaderManger()
    
    public init() {}
    
    public let appPackageName: String = "-"
    public let contentType: String = "application/json"
    public let contentAppleType: String = "application/x-www-form-urlencoded"
}
