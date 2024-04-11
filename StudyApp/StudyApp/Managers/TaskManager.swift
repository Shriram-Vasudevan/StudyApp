//
//  TaskManager.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/11/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class TaskManager: ObservableObject {
    @Published private(set) var tasks: [TaskModel] = []
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    func getTask(roomID: String) {
        db.collection("Rooms").document(roomID).collection("tasks").addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                print("Error fetching messages: \(error)")
                return
            }
            
            let tasks = querySnapshot?.documents.compactMap { queryDocumentSnapshot -> TaskModel? in
                try? queryDocumentSnapshot.data(as: TaskModel.self)
            } ?? []
            
            let sortedMessages = tasks.sorted(by: { $0.timestamp < $1.timestamp })
            self.tasks = sortedMessages
        }
        
    }
    
    func createTask(task: String, roomID: String) {
        guard let user = Auth.auth().currentUser, let displayName = user.displayName else {
            return
        }
        
        let newTask = TaskModel(id: UUID().uuidString, task: task, senderID: user.uid, senderName: displayName, timestamp: Date())
        
        do {
            try db.collection("Rooms").document(roomID).collection("tasks").document().setData(from: newTask)
        } catch {
            print("failed to send message")
        }
    }
    
}
