//
//  RoomModelArrayExtension.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/17/24.
//

import Foundation

extension Array where Element == RoomMember {
    func toDictionary() -> [[String: Any]] {
        return self.map { member in
            [
                "userID": member.userID,
                "displayName": member.displayName,
                "score": member.score
            ]
        }
    }
}
