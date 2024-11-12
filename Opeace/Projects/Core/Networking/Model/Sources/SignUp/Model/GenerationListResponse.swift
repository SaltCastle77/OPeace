//
//  GenerationListModel.swift
//  Model
//
//  Created by 염성훈 on 8/31/24.
//

import Foundation

public struct GenerationListResponse: Decodable {
     let data: GenerationDataModel?
    
}


struct GenerationDataModel: Decodable {
     let data: [String]?
    
    
}
