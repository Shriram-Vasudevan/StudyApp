//
//  EnterRoomNameWidget.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI

struct EnterRoomNameWidget: View {
    @ObservedObject var hostRoomManager: HostRoomManager
    @State var roomName: String = ""
    @Binding var isOpen: Bool
    
    @State var offset: CGFloat = 1000
    
    let customGrey: Color = Color(red: 230/255.0, green: 230/255.0, blue: 230/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .onTapGesture {
                    Task {
                        await hostRoomManager.updateRoomName(roomName: roomName)
                    }
                    
                    withAnimation (.spring()){
                        nameIsFocused = false
                        offset = 1000
                        isOpen = false
                    }
                }
                .ignoresSafeArea()
            
            
            VStack {
                HStack {
                    Text("Create a Room Name")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                
                TextField("Enter Name", text: $roomName)
                    .padding()
                    .autocapitalization(.none)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(customGrey.opacity(0.7))
                    )
                    .focused($nameIsFocused)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
            )
            .padding()
            .onAppear
            {
                withAnimation (.bouncy()){
                    offset = 0
                }
            }
            .offset(x: 0, y: offset)
        }
    }
}

#Preview {
    EnterRoomNameWidget(hostRoomManager: HostRoomManager(roomModel: RoomModel(id: "", host: "", roomName: "", roomMembers: [], backgroundImage: "JungleLake", music: "")), isOpen: .constant(true))
}
