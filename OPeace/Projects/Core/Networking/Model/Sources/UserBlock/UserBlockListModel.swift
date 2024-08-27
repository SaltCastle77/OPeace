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
    public let id, question: Int?
    public let userID, blockedUserID, blockYn, createAt: String?
    public let updateAt: String?

    public enum CodingKeys: String, CodingKey {
        case id, question
        case userID = "user_id"
        case blockedUserID = "blocked_user_id"
        case blockYn = "block_yn"
        case createAt = "create_at"
        case updateAt = "update_at"
    }
    
    public init(
        id: Int?,
        question: Int?,
        userID: String?,
        blockedUserID: String?,
        blockYn: String?,
        createAt: String?,
        updateAt: String?
    ) {
        self.id = id
        self.question = question
        self.userID = userID
        self.blockedUserID = blockedUserID
        self.blockYn = blockYn
        self.createAt = createAt
        self.updateAt = updateAt
    }
}
