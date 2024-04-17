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
        
        let id = UUID().uuidString
        let newTask = TaskModel(id: id, task: task, senderID: user.uid, senderName: displayName, timestamp: Date())
        
        do {
            try db.collection("Rooms").document(roomID).collection("tasks").document(id).setData(from: newTask)
        } catch {
            print("failed to send message")
        }
    }
    
    func deleteTask(taskID: String, roomID: String) {
        db.collection("Rooms").document(roomID).collection("tasks").document(taskID).delete()
        tasks.removeAll { Task in
            Task.id == taskID
        }
    }
    
    func taskCompleted(task: TaskModel, roomID: String) async {
        do {
            try await db.collection("Rooms").document(roomID).collection("tasks").document(task.id).delete()
            tasks.removeAll { Task in
                Task.id == task.id
            }
        } catch {
            print(error.localizedDescription)
            return
        }
        
        await updateUserScore(userID: task.senderID, roomID: roomID)
    }
    
    func updateUserScore(userID: String, roomID: String) async {
        do {
            let snapshot = try await db.collection("Rooms").document(roomID).getDocument()
            print(snapshot.data())
            var roomModel = try snapshot.data(as: RoomModel.self)
            
            var roomMembers = roomModel.roomMembers
            guard var roomMemberIndex = roomMembers.firstIndex(where: { member in
                member.userID == userID
            }) else {
                return
            }
            
            roomMembers[roomMemberIndex].score += 100
            
            let roomMembersDictionary = roomMembers.toDictionary()
            
            try await self.db.collection("Rooms").document(roomID).updateData(
                [
                    "roomMembers": roomMembersDictionary
                ]
            )
        }
        catch {
            print(error.localizedDescription)
            return
        }
    }
    
}
