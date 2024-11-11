//
//  GenerationListModel.swift
//  Model
//
//  Created by 염성훈 on 8/31/24.
//

import Foundation

public struct GenerationListResponse: Codable, Equatable {
    public let data: GenerationDataModel?
    
    public init(data: GenerationDataModel?) {
        self.data = data
    }
}


public struct GenerationDataModel: Codable, Equatable {
    public let data: [String]?
    
    public init(data: [String]?) {
        self.data = data
    }
    
}
