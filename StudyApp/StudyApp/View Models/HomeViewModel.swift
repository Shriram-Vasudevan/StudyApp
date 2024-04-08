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
    func joinRoom(roomID: String) async throws -> RoomModel {
        do {
            let dbReference = Firestore.firestore()
            
            let snapshot = try await dbReference.collection("Rooms").document(roomID).getDocument()
            print(snapshot.data())
            let roomModel = try snapshot.data(as: RoomModel.self)
            
            return roomModel
        } catch {
            print(error.localizedDescription)
            throw RoomEntryError.dataRetrievalFailed
        }
    }
    
    func roomExists(roomID: String) async -> Bool {
        do {
            let dbReference = Firestore.firestore()
            
            let snapshot = try await dbReference.collection("Rooms").document(roomID).getDocument()
            guard let snapshotData = snapshot.data() else {
                print("nil")
                return false
            }
            
            return true
        } catch {
            return false
        }
    }
    
    func addUserToRoom(roomModel: RoomModel) async {
        do {
            guard let user = Auth.auth().currentUser, let roomID = roomModel.id else { return }
            let dbRef = Firestore.firestore()
            
            try await dbRef.collection("Rooms").document(roomID).updateData(
                [
                    "roomMembers" : FieldValue.arrayUnion([user.uid])
                ]
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createRoom() async throws -> (roomID: String, userID: String) {
        do {
            guard let user = Auth.auth().currentUser else { throw AuthError.noUser }
            let dbReference = Firestore.firestore()
            
            let roomID = generateRoomID()
            
            try await dbReference.collection("Rooms").document(roomID).setData(
                [
                    "host" : user.uid,
                    "roomMembers": [user.uid],
                    "roomName": "Room Name"
                ]
            )
            
            return (roomID, user.uid)
        }
        catch {
            throw AuthError.creationFailed
        }
    }
    
    func generateRoomID() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        var randomString = ""
        
        for number in 0..<6 {
            let randomIndex = Int.random(in: 0..<26)
            let randomCharIndex = letters.index(letters.startIndex, offsetBy: randomIndex)
            randomString.append(letters[randomCharIndex])
        }
        
        return randomString
    }
}

enum RoomEntryError: Error {
    case dataRetrievalFailed
}
enum AuthError: Error {
    case noUser, creationFailed
}
