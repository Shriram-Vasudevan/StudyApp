//
//  HostsRoom.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI

struct HostsRoom: View {
    @ObservedObject var taskManager: TaskManager
    @ObservedObject var messageManager: MessageManager
    @ObservedObject var hostsRoomViewModel: HostsRoomViewModel
    
    let customGrey: Color = Color(red: 248/255.0, green: 252/255.0, blue: 252/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
    @State var showEnterRoomNameWidget: Bool = false
    @State var showChatView: Bool = false
    
    @State var showTaskCreationSheet: Bool = false
    @State var task: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack (alignment: .leading) {
                        HStack {
                            Text(hostsRoomViewModel.roomModel.roomName.isEmpty ? "Room Name" : hostsRoomViewModel.roomModel.roomName)
                                .foregroundColor(.white)
                                .bold()
                                .font(.title)
                                .onTapGesture {
                                    showEnterRoomNameWidget = true
                                }
                            
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                            
                        }
                        
                        if let id = hostsRoomViewModel.roomModel.id {
                            Text(id.isEmpty ? "Error Loading ID" : id)
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        hostsRoomViewModel.closeRoom()
                        
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
                        ForEach(hostsRoomViewModel.roomModel.roomMembers, id: \.self) { member in
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
                    VStack (spacing: 0){
                        VStack (spacing: 0) {
                            HStack {
                                Text("Leaderboard")
                                    .foregroundColor(.black)
                                    .font(.title)
                                    .bold()
                                
                                Spacer()
                                
                            }
                            
                            ForEach(hostsRoomViewModel.roomModel.roomMembers.sorted(by: { $0.score > $1.score}), id: \.userID) { member in
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
                            
                            if let roomID = hostsRoomViewModel.roomModel.id {
                                ForEach(taskManager.tasks, id: \.id) { task in
                                    Divider()
                                    TaskView(roomID: roomID,task: task, taskManager: taskManager) { taskID in
    
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
                    Image("Jungle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipped()
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.white, lineWidth: 2)
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
                EnterRoomNameWidget(hostsRoomViewModel: hostsRoomViewModel, isOpen: $showEnterRoomNameWidget)
                    .transition(.opacity)
            }
            
            if showTaskCreationSheet, let id = hostsRoomViewModel.roomModel.id {
                TaskCreationView(taskManager: taskManager, isOpen: $showTaskCreationSheet, roomID: id)
                    .transition(.opacity)
            }
        }
        .sheet(isPresented: $showChatView, content: {
            if let roomID = hostsRoomViewModel.roomModel.id {
                ChatView(messageManager: messageManager, roomID: roomID)
            }
        })
        .onAppear {
            showEnterRoomNameWidget = true
            hostsRoomViewModel.listenForRoomUpdates()
            
            guard let roomID = hostsRoomViewModel.roomModel.id else { return }
            
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
    HostsRoom(taskManager: TaskManager(), messageManager: MessageManager(), hostsRoomViewModel: HostsRoomViewModel(roomModel: RoomModel(id: "test", host: "rffw8efy948yr9r8", roomName: "Shriram's Room", roomMembers: [])))
}
