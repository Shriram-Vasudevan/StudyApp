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
    var task: TaskModel
    
    var body: some View {
        if task.senderID == Auth.auth().currentUser?.uid {
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
    TaskView(task: TaskModel(id: "", task: "Need to study for Chem", senderID: "", senderName: "Shriram", timestamp: Date()))
}
