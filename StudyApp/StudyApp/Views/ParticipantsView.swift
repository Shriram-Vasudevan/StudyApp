//
//  ParticipantsView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI

struct ParticipantsView: View {
    @ObservedObject var messageManager: MessageManager
    @ObservedObject var participantsViewModel: ParticipantsViewModel
    
    let customGrey: Color = Color(red: 248/255.0, green: 252/255.0, blue: 252/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
    @State var showChatView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                        .foregroundColor(.white)
                        .scaleEffect(x: -1, y: 1)
                    
                    Text(participantsViewModel.roomModel.roomName.isEmpty ? "Room Name" : participantsViewModel.roomModel.roomName)
                        .foregroundColor(.white)
                        .bold()
                        .font(.title)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    ForEach(participantsViewModel.roomModel.roomMembers, id: \.self) { member in
                        Text(member.split(separator: "-")[1])
                            .font(.headline)
                            .foregroundColor(.black)
                            .bold()
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.white)
                            )
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
        }
        .background(
            customBlue
        )
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ParticipantsView(messageManager: MessageManager(), participantsViewModel: ParticipantsViewModel(roomModel: RoomModel(id: "test", host: "fewfwdfrwe", roomName: "Shriram's Room", roomMembers: ["fewfwdfrwe=Shriram"])))
}
