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
    
    @State var roomID: String = ""
    
    @State var roomInformation: (String, String, String) = ("", "", "")
    @State var roomModel: RoomModel?
    
    let customGrey: Color = Color(red: 248/255.0, green: 252/255.0, blue: 252/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack (spacing: 0) {
                    HStack {
                        Text("Hello \(homeViewModel.getDisplayName())")
                            .foregroundColor(.black)
                            .font(.custom("EtruscoNowCondensed Bold", size: 40))
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            authenticationManager.signOut {
                                pageType = .authentication
                            }
                        }, label: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 20, height: 20)
                        })
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        VStack (spacing: 0) {
                            Button(action: {
                                showEnterRoomIDView = true
                            }, label: {
                                Image("TeensStudying")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height:  UIScreen.main.bounds.height / 4)
                                    .cornerRadius(10)
                                    .overlay (
                                        Text("Join a Room")
                                            .font(.custom("Sailec Bold", size: 25))
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(.black.opacity(0.4))
                                            ),
                                        alignment: .center
                                    )
                                    .padding(.horizontal)
                            })
                            
                            HStack {
                                Text("Friends")
                                    .foregroundColor(.black)
                                    .font(.custom("EtruscoNowCondensed Bold", size: 35))
                                    .bold()
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            HStack {
                                Text("Your Stats")
                                    .foregroundColor(.black)
                                    .font(.custom("EtruscoNowCondensed Bold", size: 35))
                                    .bold()
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                        }
                        
                    }
                }
                
                if showEnterRoomIDView {
                    EnterRoomIDWidget(homeViewModel: homeViewModel, isOpen: $showEnterRoomIDView) { roomModel in
                        self.roomModel = roomModel
                        navigateToParticipantRoom = true
                    }
                    .transition(.opacity)
                }
                
                VStack {
                    Spacer()
                    
                    Button {
                        Task {
                            do {
                                let roomInformation = try await homeViewModel.createRoom()
                                self.roomInformation = roomInformation
                                
                                navigateToHostRoom = true
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 23, height: 23)
                            .padding()
                            .background(
                                Circle()
                                    .fill(customBlue)
                            )
                            .padding()
                    }
                }
                
            }
            .navigationDestination(isPresented: $navigateToParticipantRoom, destination: {
                if let roomModel = self.roomModel {
                    ParticipantsView(taskManager: TaskManager(), messageManager: messageManager, participantsViewModel: ParticipantsViewModel(roomModel: roomModel))
                }
            })
            .navigationDestination(isPresented: $navigateToHostRoom, destination: {
                HostsRoom(taskManager: taskManager, messageManager: messageManager, hostsRoomViewModel: HostsRoomViewModel(roomModel: RoomModel(id: roomInformation.0, host: roomInformation.1, roomName: "Room Name", roomMembers: [RoomMember(userID: roomInformation.1, displayName: roomInformation.2, score: 0)])))
            })
            .background(
                .white
            )
        }
    }
}

#Preview {
    Home(pageType: .constant(.main))
}
