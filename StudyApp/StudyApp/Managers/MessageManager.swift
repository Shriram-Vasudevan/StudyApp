//
//  MessageManager.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/9/24.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage

class MessageManager: ObservableObject {
    @Published private(set) var messages: [Message] = []
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
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
