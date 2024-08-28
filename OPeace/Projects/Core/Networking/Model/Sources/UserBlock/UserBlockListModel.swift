//
//  UserBlockListModel.swift
//  Model
//
//  Created by 서원지 on 8/27/24.
//

// MARK: - Welcome
public struct UserBlockListModel: Codable, Equatable {
    public let data: [UserBlockListResponseModel]?
    
    public init(
        data: [UserBlockListResponseModel]?
    ) {
        self.data = data
    }
}

// MARK: - Datum
public struct UserBlockListResponseModel: Codable, Equatable {
    public let blockID: Int?
    public let blockedUserID, nickname, job, generation: String?
    
    public enum CodingKeys: String, CodingKey {
        case blockID = "block_id"
        case blockedUserID = "blocked_user_id"
        case nickname, job, generation
    }
    
    public init(
        blockID: Int?,
        blockedUserID: String?,
        nickname: String?,
        job: String?,
        generation: String?
    ) {
        self.blockID = blockID
        self.blockedUserID = blockedUserID
        self.nickname = nickname
        self.job = job
        self.generation = generation
    }
}
