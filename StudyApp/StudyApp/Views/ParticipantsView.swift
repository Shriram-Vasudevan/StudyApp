//
//  ParticipantsView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI

struct ParticipantsView: View {
    @ObservedObject var taskManager: TaskManager
    @ObservedObject var messageManager: MessageManager
    @ObservedObject var participantsViewModel: ParticipantsViewModel
    
    let customGrey: Color = Color(red: 248/255.0, green: 252/255.0, blue: 252/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
    @State var showChatView: Bool = false
    
    @State var showTaskCreationSheet: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(participantsViewModel.roomModel.roomName.isEmpty ? "Room Name" : participantsViewModel.roomModel.roomName)
                        .foregroundColor(.white)
                        .bold()
                        .font(.title)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await participantsViewModel.leaveRoom()
                        }
                        
                        dismiss()
  
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .foregroundColor(.white)
                            .scaleEffect(x: -1, y: 1)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(participantsViewModel.roomModel.roomMembers, id: \.self) { member in
                            HStack {
                                Image("Man Smiling")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(5)
                                    .clipped()
                                    
                                
                                Text(member.displayName)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .bold()
                            }
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.white)
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.vertical) {
                    VStack (spacing: 0) {
                        VStack (spacing: 0) {
                            HStack {
                                Text("Leaderboard")
                                    .foregroundColor(.black)
                                    .font(.title)
                                    .bold()
                                
                                Spacer()
                                
                            }
                            
                            ForEach(participantsViewModel.roomModel.roomMembers.sorted(by: { $0.score > $1.score}), id: \.userID) { member in
                                Divider()
                                ScoreWidget(roomMember: member)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.white)
                        )
                        .padding()
                        
                        VStack (spacing: 0) {
                            HStack {
                                Text("Tasks")
                                    .foregroundColor(.black)
                                    .font(.title)
                                    .bold()
                                
                                Spacer()
                                
                                Button {
                                    showTaskCreationSheet = true
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .foregroundColor(.black)
                                        .frame(width: 20, height: 20)
                                }

                            }
                            
                            if let roomID = participantsViewModel.roomModel.id {
                                ForEach(taskManager.tasks, id: \.id) { task in
                                    TaskView(roomID: roomID, task: task, taskManager: taskManager) { taskID in
                                        
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.white)
                        )
                        .padding()
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showChatView = true
                    }, label: {
                        Image(systemName: "message.fill")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                            )
                    })
                }
                .padding(.horizontal)
            }
            
            if showTaskCreationSheet, let id = participantsViewModel.roomModel.id {
                TaskCreationView(taskManager: taskManager, isOpen: $showTaskCreationSheet, roomID: id)
                    .transition(.opacity)
            }
        }
        .sheet(isPresented: $showChatView, content: {
            if let roomID = participantsViewModel.roomModel.id {
                ChatView(messageManager: messageManager, roomID: roomID)
            }
        })
        .onAppear {
            participantsViewModel.listenForRoomUpdates()
            guard let roomID = participantsViewModel.roomModel.id else { return }
            
            messageManager.getMessage(roomID: roomID)
            taskManager.getTask(roomID: roomID)
        }
        .background(
            Image("Jungle")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ParticipantsView(taskManager: TaskManager(), messageManager: MessageManager(), participantsViewModel: ParticipantsViewModel(roomModel: RoomModel(id: "test", host: "fewfwdfrwe", roomName: "Shriram's Room", roomMembers: [])))
}
