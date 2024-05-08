//
//  TaskView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/11/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct TaskView: View {
    var roomID: String
    var task: TaskModel
    var taskManager: TaskManager
    
    var taskCompleted: (TaskModel) -> Void
    
    var body: some View {
        if task.senderID == Auth.auth().currentUser?.uid {
            HStack {
                Text("\(task.senderName): \(task.task)")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button {
                    withAnimation {
                        taskManager.deleteTask(taskID: task.id, roomID: roomID)
                    }
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                
                Button {
                    taskCompleted(task)
                } label: {
                    Image(systemName: "flag.checkered")
                        .foregroundColor(.black)
                }

            }
            .padding(.vertical)
            .background(
                Rectangle()
                    .fill(.white)
            )
        } else {
            HStack {
                Text("\(task.senderName): \(task.task)")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.vertical)
            .background(
                Rectangle()
                    .fill(.white)
            )
        }
    }
}

#Preview {
    TaskView(roomID: "", task: TaskModel(id: "", task: "Need to study for Chem", senderID: "", senderName: "Shriram", timestamp: Date()), taskManager: TaskManager(), taskCompleted: {taskID in})
}
