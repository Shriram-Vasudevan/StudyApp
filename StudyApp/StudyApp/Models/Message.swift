//
//  Message.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/9/24.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var message: String
    var senderID: String
    var senderName: String
    var timestamp: Date
}
