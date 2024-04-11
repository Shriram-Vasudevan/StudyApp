//
//  Home.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/6/24.
//

import SwiftUI

struct Home: View {
    @StateObject var taskManager = TaskManager()
    @StateObject var messageManager = MessageManager()
    @ObservedObject var homeViewModel = HomeViewModel()
    var authenticationManager = AuthenticationManager()
    
    @Binding var pageType: PageType
    @State var navigateToHostRoom: Bool = false
    @State var navigateToParticipantRoom: Bool = false
    @State var showEnterRoomIDView: Bool = false
    
    @State var roomInformation: (String, String, String) = ("", "", "")
    @State var roomModel: RoomModel?
    
    let customGrey: Color = Color(red: 248/255.0, green: 252/255.0, blue: 252/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Text(homeViewModel.getDisplayName())
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            authenticationManager.signOut {
                                pageType = .authentication
                            }
                        }, label: {
                            Image(systemName: "person.fill")
                                .foregroundColor(.black)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white)
                                )
                        })
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            do {
                                let roomInformation = try await homeViewModel.createRoom()
                                self.roomInformation = roomInformation
                                
                                navigateToHostRoom = true
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }, label: {
                        VStack {
                            Text("Create Room")
                                .foregroundColor(.black)
                                .bold()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        )
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        showEnterRoomIDView = true
                    }, label: {
                        VStack {
                            Text("Join Room")
                                .foregroundColor(.black)
                                .bold()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        )
                    })
                    
                    Spacer()
                }
                
                if showEnterRoomIDView {
                    EnterRoomIDWidget(homeViewModel: homeViewModel, isOpen: $showEnterRoomIDView) { roomModel in
                        self.roomModel = roomModel
                        navigateToParticipantRoom = true
                    }
                    .transition(.opacity)
                }
            }
            .navigationDestination(isPresented: $navigateToParticipantRoom, destination: {
                if let roomModel = self.roomModel {
                    ParticipantsView(taskManager: TaskManager(), messageManager: messageManager, participantsViewModel: ParticipantsViewModel(roomModel: roomModel))
                }
            })
            .navigationDestination(isPresented: $navigateToHostRoom, destination: {
                HostsRoom(taskManager: taskManager, messageManager: messageManager, hostsRoomViewModel: HostsRoomViewModel(roomModel: RoomModel(id: roomInformation.0, host: roomInformation.1, roomName: "Room Name", roomMembers: ["\(roomInformation.1)-\(roomInformation.2)"])))
            })
            .background(
                customBlue
            )
        }
    }
}

#Preview {
    Home(pageType: .constant(.main))
}
