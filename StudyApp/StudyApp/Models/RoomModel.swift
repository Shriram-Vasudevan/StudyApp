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
    var roomMembers: [String]
    var timer: Double?
    var backgroundImage: String?
    
}
