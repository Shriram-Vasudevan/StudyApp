//
//  TaskCreationView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/11/24.
//

import SwiftUI

struct TaskCreationView: View {
    @ObservedObject var taskManager: TaskManager
    
    @Binding var isOpen: Bool
    @State var offset: CGFloat = 1000
    
    @State var roomID: String
    @State var task: String = ""
    
    let customGrey: Color = Color(red: 248/255.0, green: 252/255.0, blue: 252/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .onTapGesture {
                    print("tapped outside")
                    withAnimation (.spring(duration: 1)){
                        nameIsFocused = false
                        offset = 1000
                        isOpen = false
                    }
                }
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Add Task")
                        .foregroundColor(.black)
                        .font(.title)
                        .bold()
                    
                    Spacer()
                }
                
                TextField("Enter Text", text: $task)
                    .padding()
                    .autocapitalization(.none)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(customGrey)
                    )
                    .focused($nameIsFocused)
                
                Button(action: {
                    taskManager.createTask(task: task, roomID: roomID)

                    withAnimation (.spring()){
                        nameIsFocused = false
                        offset = 1000
                        isOpen = false
                    }
                }) {
                    Text("Enter")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .cornerRadius(7)
                        .shadow(radius: 3)
                        .padding(.top)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
            )
            .padding()
            .onAppear
            {
                withAnimation (.bouncy()){
                    offset = 0
                }
            }
            .offset(x: 0, y: offset)
        }
    }
}

#Preview {
    TaskCreationView(taskManager: TaskManager(), isOpen: .constant(true), roomID: "")
}
