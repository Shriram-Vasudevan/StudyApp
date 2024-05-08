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
    @ObservedObject var participantRoomManager: ParticipantRoomManager
    @ObservedObject var AIManager: AIManager
    
    let customGrey: Color = Color(red: 248/255.0, green: 252/255.0, blue: 252/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
    @State var showChatView: Bool = false
    
    @State var showTaskCreationSheet: Bool = false
    
    @State var showAIAssistantSheet: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                HStack {
                    Text(participantRoomManager.roomModel.roomName.isEmpty ? "Room Name" : participantRoomManager.roomModel.roomName)
                        .foregroundColor(.white)
                        .bold()
                        .font(.title)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await participantRoomManager.leaveRoom()
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
                        ForEach(participantRoomManager.roomModel.roomMembers, id: \.self) { member in
                            HStack {
                                Image("Kevin")
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
                .padding()
                
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
                            
                            ForEach(participantRoomManager.roomModel.roomMembers.sorted(by: { $0.score > $1.score}), id: \.userID) { member in
                                Divider()
                                ScoreWidget(roomMember: member)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.white)
                        )
                        .padding(.horizontal)
                        .padding(.top)
                        
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
                            
                            if let roomID = participantRoomManager.roomModel.id {
                                ForEach(taskManager.tasks, id: \.id) { task in
                                    TaskView(roomID: roomID, task: task, taskManager: taskManager) { task in
                                        Task {
                                            await taskManager.taskCompleted(task: task, roomID: roomID)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.white)
                        )
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Button {
                            showAIAssistantSheet = true
                        } label: {
                            VStack (spacing: 0) {
                                HStack {
                                    Image("Kevin")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 150)
                                    
                                    Spacer()
                                    
                                    Text("Need Some Help?")
                                        .multilineTextAlignment(.center)
                                        .font(.title)
                                        .bold()
                                }
    //                            .padding(.horizontal)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.white)
                            )
                            .padding(.horizontal)
                            .padding(.top)
                        }
                        
                        Button {
                            if participantRoomManager.musicOn {
                                participantRoomManager.pauseMusic()
                            } else {
                                participantRoomManager.changeMusic()
                            }
                        } label: {
                            HStack {
                                Text(participantRoomManager.roomModel.music)
                                    .font(.custom("EtruscoNowCondensed Bold", size: 35))
                                    .bold()
                                
                                Spacer()
                                
                                Circle()
                                    .fill(.green)
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        Image(systemName: participantRoomManager.musicOn ? "play.fill" : "pause.fill")
                                            .foregroundColor(.black)
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
            
            if showTaskCreationSheet, let id = participantRoomManager.roomModel.id {
                TaskCreationView(taskManager: taskManager, isOpen: $showTaskCreationSheet, roomID: id)
                    .transition(.opacity)
            }
        }
        .sheet(isPresented: $showAIAssistantSheet, content: {
            AIChatView(AIManager: AIManager)
        })
        .sheet(isPresented: $showChatView, content: {
            if let roomID = participantRoomManager.roomModel.id {
                ChatView(messageManager: messageManager, roomID: roomID, roomBackground: participantRoomManager.roomModel.backgroundImage)
            }
        })
        .onAppear {
            participantRoomManager.listenForRoomUpdates()
            guard let roomID = participantRoomManager.roomModel.id else { return }
            
            messageManager.getMessage(roomID: roomID)
            taskManager.getTask(roomID: roomID)
        }
        .background(
            Image(participantRoomManager.roomModel.backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ParticipantsView(taskManager: TaskManager(), messageManager: MessageManager(), participantRoomManager: ParticipantRoomManager(roomModel: RoomModel(id: "test", host: "fewfwdfrwe", roomName: "Shriram's Room", roomMembers: [], backgroundImage: "JungleLake", music: "")), AIManager: AIManager())
}
