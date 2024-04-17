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
    func getDisplayName() -> String {
        guard let user = Auth.auth().currentUser, let userDisplay = user.displayName else { return "Dave!"}
        
        return userDisplay
    }
    
    func joinRoom(roomID: String) async throws -> RoomModel {
        do {
            guard let user = Auth.auth().currentUser, let displayName = user.displayName else {
                throw AuthError.noUser
            }
            
            let dbReference = Firestore.firestore()
            
            let snapshot = try await dbReference.collection("Rooms").document(roomID).getDocument()
            print(snapshot.data())
            var roomModel = try snapshot.data(as: RoomModel.self)
            
            await addUserToRoom(roomModel: roomModel)
            roomModel.roomMembers.append(RoomMember(userID: user.uid, displayName: displayName, score: 0))
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
            guard let user = Auth.auth().currentUser, let roomID = roomModel.id, let userDisplayName = user.displayName else { return }
            let dbRef = Firestore.firestore()
            
            try await dbRef.collection("Rooms").document(roomID).updateData(
                [
                    "roomMembers" : FieldValue.arrayUnion([RoomMember(userID: user.uid, displayName: userDisplayName, score: 0)])
                ]
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createRoom() async throws -> (roomID: String, hostID: String, hostDisplayName: String) {
        do {
            guard let user = Auth.auth().currentUser, let userDisplayName = user.displayName else { throw AuthError.noUser }
            let dbReference = Firestore.firestore()
            
            let roomID = generateRoomID()
            
            let roomMember: [String: Any] = [
                    "userID": user.uid,
                    "displayName": userDisplayName,
                    "score": 0
            ]
            
            try await dbReference.collection("Rooms").document(roomID).setData(
                [
                    "host" : user.uid,
                    "roomMembers": [roomMember],
                    "roomName": "Room Name",
                    "backgroundImage": "Jungle"
                ]
            )
            
            return (roomID, user.uid, userDisplayName)
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
