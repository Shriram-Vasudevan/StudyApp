//
//  HomeViewModel.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/6/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class HomeViewModel: ObservableObject {
    func createRoom() async throws {
        do {
            guard let user = Auth.auth().currentUser else { throw AuthError.noUser }
            let dbReference = Firestore.firestore()
            
            let roomID = generateRoomID()
            
            try await dbReference.collection("Rooms").document(roomID).setData(
                [
                    "Host" : user.uid,
                    "Users": [user.uid]
                ]
            )
        }
        catch {
            throw AuthError.creationFailed
        }
    }
    
    func generateRoomID() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        var randomString = ""
        
        for number in 0..<6 {
            let randomIndex = Int.random(in: 0..<6)
            let randomCharIndex = letters.index(letters.startIndex, offsetBy: randomIndex)
            randomString.append(letters[randomCharIndex])
        }
        
        return randomString
    }
}

enum AuthError: Error {
    case noUser, creationFailed
}
