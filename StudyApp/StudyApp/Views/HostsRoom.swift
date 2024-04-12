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
                    Text(hostsRoomViewModel.roomModel.roomName.isEmpty ? "Room Name" : hostsRoomViewModel.roomModel.roomName)
                        .foregroundColor(.white)
                        .bold()
                        .font(.title)
                        .onTapGesture {
                            showEnterRoomNameWidget = true
                        }
                    
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        hostsRoomViewModel.closeRoom()
                        
                        dismiss()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .foregroundColor(.white)
                            .scaleEffect(x: -1, y: 1)
                    }

                }
                .padding(.horizontal)
                
                HStack {
                    if let id = hostsRoomViewModel.roomModel.id {
                        Text(id.isEmpty ? "Error Loading ID" : id)
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
                
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
                                    
                                
                                Text(member.split(separator: "-")[1])
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
                    
                    ForEach(taskManager.tasks, id: \.id) { task in
                        Divider()
                        TaskView(task: task)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white)
                )
                .padding()
                
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
            
            if showEnterRoomNameWidget {
                EnterRoomNameWidget(roomName: $hostsRoomViewModel.roomModel.roomName, isOpen: $showEnterRoomNameWidget)
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
        .onChange(of: hostsRoomViewModel.roomModel.roomName) { roomName in
            Task {
                await hostsRoomViewModel.updateRoomName(roomName: roomName)
            }
        }
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
    HostsRoom(taskManager: TaskManager(), messageManager: MessageManager(), hostsRoomViewModel: HostsRoomViewModel(roomModel: RoomModel(id: "test", host: "rffw8efy948yr9r8", roomName: "Shriram's Room", roomMembers: ["rffw8efy948yr9r8-Shriram"])))
}
