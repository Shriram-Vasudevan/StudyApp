//
//  ParticipantsViewModel.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ParticipantsViewModel: ObservableObject {
    @Published var roomModel: RoomModel
    @Published private(set) var messages: [Message] = []
    @Published private(set) var tasks: [TaskModel] = []
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init(roomModel: RoomModel) {
        self.roomModel = roomModel
    }

    func leaveRoom() async {
        do {
            guard let user = Auth.auth().currentUser, let roomID = roomModel.id, let userDisplayName = user.displayName else { return }
            
            try await db.collection("Rooms").document(roomID).updateData(
                [
                    "roomMembers" : FieldValue.arrayRemove(["\(user.uid)-\(userDisplayName)"])
                ]
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func listenForRoomUpdates() {
        guard let roomID = roomModel.id else { return }
        
        db.collection("Rooms").document(roomID)
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
    
    func getMessage(roomID: String) {
        db.collection("Rooms").document(roomID).collection("chat").addSnapshotListener { querySnapshot, error in
            
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
        guard let user = Auth.auth().currentUser, let displayName = user.displayName else {
            return
        }
        
        let newMessage = Message(id: UUID().uuidString, message: message, senderID: user.uid, senderName: displayName, timestamp: Date())
        
        do {
            try db.collection("Rooms").document(roomID).collection("chat").document().setData(from: newMessage)
        } catch {
            print("failed to send message")
        }
    }

}
