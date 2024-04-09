//
//  ParticipantsView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI

struct ParticipantsView: View {
    @ObservedObject var participantsViewModel: ParticipantsViewModel
    
    let customGrey: Color = Color(red: 248/255.0, green: 252/255.0, blue: 252/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
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
            }
        }
        .onAppear {
            participantsViewModel.listenForRoomUpdates()
        }
        .background(
            customBlue
        )
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ParticipantsView(participantsViewModel: ParticipantsViewModel(roomModel: RoomModel(id: "test", host: "fewfwdfrwe", roomName: "Shriram's Room", roomMembers: ["fewfwdfrwe=Shriram"])))
}
