//
//  HostsRoom.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI
import AVKit

struct HostsRoom: View {
    @ObservedObject var taskManager: TaskManager
    @ObservedObject var messageManager: MessageManager
    @ObservedObject var hostRoomManager: HostRoomManager
    @ObservedObject var AIManager: AIManager
    
    let customGrey: Color = Color(red: 248/255.0, green: 252/255.0, blue: 252/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
    @State var showEnterRoomNameWidget: Bool = false
    @State var showChatView: Bool = false
    
    @State var showTaskCreationSheet: Bool = false
    @State var task: String = ""
    
    @State var showAIAssistantSheet: Bool = false
    
    @State var showChangeBackgroundWidget: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                HStack {
                    VStack (alignment: .leading) {
                        HStack {
                            Text(hostRoomManager.roomModel.roomName.isEmpty ? "Room Name" : hostRoomManager.roomModel.roomName)
                                .foregroundColor(.white)
                                .bold()
                                .font(.title)
                                .onTapGesture {
                                    showEnterRoomNameWidget = true
                                }
                            
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                            
                        }
                        
                        if let id = hostRoomManager.roomModel.id {
                            Text(id.isEmpty ? "Error Loading ID" : id)
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        hostRoomManager.closeRoom()
                        
                        dismiss()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .foregroundColor(.white)
                            .scaleEffect(x: -1, y: 1)
                            .padding()
                            .background(
                                Circle()
                                    .fill(.gray.opacity(0.2))
                            )
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(hostRoomManager.roomModel.roomMembers, id: \.self) { member in
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
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                ScrollView(.vertical) {
                    VStack (spacing: 0){
                        VStack (spacing: 0) {
                            HStack {
                                Text("Leaderboard")
                                    .foregroundColor(.black)
                                    .font(.title)
                                    .bold()
                                
                                Spacer()
                                
                            }
                            
                            ForEach(hostRoomManager.roomModel.roomMembers.sorted(by: { $0.score > $1.score}), id: \.userID) { member in
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
                            
                            if let roomID = hostRoomManager.roomModel.id {
                                ForEach(taskManager.tasks, id: \.id) { task in
                                    Divider()
                                    TaskView(roomID: roomID,task: task, taskManager: taskManager) { task in
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
                            if hostRoomManager.musicOn {
                                hostRoomManager.pauseMusic()
                            } else {
                                hostRoomManager.changeAVPlayerMusic()
                            }
                        } label: {
                            HStack {
                                Text(hostRoomManager.roomModel.music)
                                    .font(.custom("EtruscoNowCondensed Bold", size: 35))
                                    .foregroundColor(.black)
                                    .bold()
                                
                                Spacer()
                                
                                Circle()
                                    .fill(.green)
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        Image(systemName: hostRoomManager.musicOn ? "play.fill" : "pause.fill")
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
                    Button {
                        showChangeBackgroundWidget = true
                    } label: {
                        Image(hostRoomManager.roomModel.backgroundImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipped()
                            .cornerRadius(10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.white, lineWidth: 2)
                            }
                    }

                    
                    Spacer()
                    
                    Button(action: {
                        showChatView = true
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 52, height: 52)
                            .overlay {
                                Image(systemName: "message.fill")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 23, height: 24)
                            }
                    })
                }
                .padding(.horizontal)
            }
            
            if showEnterRoomNameWidget {
                EnterRoomNameWidget(hostRoomManager: hostRoomManager, isOpen: $showEnterRoomNameWidget)
                    .transition(.opacity)
            }
            
            if showTaskCreationSheet, let id = hostRoomManager.roomModel.id {
                TaskCreationView(taskManager: taskManager, isOpen: $showTaskCreationSheet, roomID: id)
                    .transition(.opacity)
            }
            
            if showChangeBackgroundWidget {
                PickBackgroundView(hostRoomManager: hostRoomManager, isOpen: $showChangeBackgroundWidget)
            }
        }
        .sheet(isPresented: $showAIAssistantSheet, content: {
            AIChatView(AIManager: AIManager)
        })
        .sheet(isPresented: $showChatView, content: {
            if let roomID = hostRoomManager.roomModel.id {
                ChatView(messageManager: messageManager, roomID: roomID, roomBackground: hostRoomManager.roomModel.backgroundImage)
            }
        })
        .onAppear {
            showEnterRoomNameWidget = true
            hostRoomManager.listenForRoomUpdates()
            
            guard let roomID = hostRoomManager.roomModel.id else { return }
            
            messageManager.getMessage(roomID: roomID)
            taskManager.getTask(roomID: roomID)
        }
        .background(
            Image(hostRoomManager.roomModel.backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HostsRoom(taskManager: TaskManager(), messageManager: MessageManager(), hostRoomManager: HostRoomManager(roomModel: RoomModel(id: "test", host: "rffw8efy948yr9r8", roomName: "Shriram's Room", roomMembers: [], backgroundImage: "JungleLake", music: "")), AIManager: AIManager())
}
