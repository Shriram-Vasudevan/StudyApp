//
//  HostsRoom.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI

struct HostsRoom: View {
    @ObservedObject var hostsRoomViewModel: HostsRoomViewModel
    @State var showEnterRoomNameWidget: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                        .foregroundColor(.white)
                        .scaleEffect(x: -1, y: 1)
//                        .padding(6)
//                        .background(
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(.white)
//                        )
                    
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
                }
                .padding(.horizontal)
                
                Spacer()
            }
            
            if showEnterRoomNameWidget {
                EnterRoomNameWidget(roomName: $hostsRoomViewModel.roomModel.roomName, isOpen: $showEnterRoomNameWidget)
                    .transition(.opacity)
            }
        }
        .onChange(of: hostsRoomViewModel.roomModel.roomName) { roomName in
            Task {
                await hostsRoomViewModel.updateRoomName(roomName: roomName)
            }
        }
        .onAppear {
            showEnterRoomNameWidget = true
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
    HostsRoom(hostsRoomViewModel: HostsRoomViewModel(roomModel: RoomModel(id: "test", host: "rffw8efy948yr9r8", roomName: "Shriram's Room", roomMembers: ["rffw8efy948yr9r8"])))
}
