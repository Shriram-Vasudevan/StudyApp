
//
//  Task.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/11/24.
//

import Foundation

struct TaskModel: Identifiable, Codable {
    var id: String
    var task: String
    var senderID: String
    var senderName: String
    var timestamp: Date
}
