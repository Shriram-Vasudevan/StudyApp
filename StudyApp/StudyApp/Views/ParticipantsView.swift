//
//  ParticipantsView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI

struct ParticipantsView: View {
    @ObservedObject var participantsViewModel: ParticipantsViewModel
    
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
                
                Spacer()
            }
        }
        .background(
            Image("CardTable")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ParticipantsView(participantsViewModel: ParticipantsViewModel(roomModel: RoomModel(id: "test", host: "fewfwdfrwe", roomName: "Shriram's Name", roomMembers: ["fewfwdfrwe", "fihewoifhwefhew"])))
}
