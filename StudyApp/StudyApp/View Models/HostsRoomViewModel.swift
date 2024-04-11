//
//  HostsRoomViewModel.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class HostsRoomViewModel: ObservableObject {
    @Published var roomModel: RoomModel
    @Published private(set) var messages: [Message] = []
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init(roomModel: RoomModel) {
        self.roomModel = roomModel
    }
    
    func closeRoom() {
        
    }
    
    func updateRoomName(roomName: String) async {
        do {
            DispatchQueue.main.async {
                self.roomModel.roomName = roomName
            }
            
            guard let roomID = roomModel.id else { return }
            let dbRef = Firestore.firestore()
            
            try await dbRef.collection("Rooms").document(roomID).updateData(
                [
                    "roomName" : roomName
                ]
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func listenForRoomUpdates() {
        guard let roomID = roomModel.id else { return }
        let dbReference = Firestore.firestore()
        
        dbReference.collection("Rooms").document(roomID)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
                print("\(source) data: \(document.data() ?? [:])")
                
                do {
                    let roomModel = try document.data(as: RoomModel.self)
                    self.roomModel = roomModel
                } catch {
                    return
                }
          }
    }
    
    func getMessage() {
        guard let id = roomModel.id else { return }
        db.collection("Rooms").document(id).collection("chat").addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                print("Error fetching messages: \(error)")
                return
            }
            
            let messages = querySnapshot?.documents.compactMap { queryDocumentSnapshot -> Message? in
                try? queryDocumentSnapshot.data(as: Message.self)
            } ?? []
            
            let sortedMessages = messages.sorted(by: { $0.timestamp < $1.timestamp })
            self.messages = sortedMessages
        }
        
    }
    
    func sendMessage(message: String, roomID: String) {
        guard let id = roomModel.id, let user = Auth.auth().currentUser, let displayName = user.displayName else {
            return
        }
        
        let newMessage = Message(id: UUID().uuidString, message: message, senderID: user.uid, senderName: displayName, timestamp: Date())
        
        do {
            try db.collection("Rooms").document(id).collection("chat").document().setData(from: newMessage)
        } catch {
            print("failed to send message")
        }
    }
    
}
