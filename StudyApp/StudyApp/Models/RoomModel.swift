//
//  RoomModel.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import Foundation
import FirebaseFirestore

struct RoomModel: Identifiable, Codable {
    @DocumentID var id: String?
    var host: String
    var roomName: String
    var roomMembers: [RoomMember]
    var backgroundImage: String
    var music: String
//    var timer: Double?

    
}

struct RoomMember: Codable, Hashable {
    var userID: String
    var displayName: String
    var score: Int
}
