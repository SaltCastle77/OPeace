//
//  APIHeader.swift
//  Foundations
//
//  Created by 서원지 on 7/18/24.
//

import Foundation

struct APIHeader{
    
    static let contentType = "Content-Type"
    static let appPackageName = "App-Package-Name"
    static let apikey =  "apikey"
    static let cookie = "Cookie"
    
}

extension APIHeader {
    static var baseHeader: Dictionary<String, String> {
        [
          contentType : APIHeaderManger.shared.contentType
        ]
    }
}
