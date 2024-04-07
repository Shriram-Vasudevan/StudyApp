//
//  HostsRoom.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI

struct HostsRoom: View {
    @State var showEnterRoomNameWidget: Bool = false
    @State var roomName: String = ""
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(roomName.isEmpty ? "Shriram's Room" : roomName)
                        .foregroundColor(.white)
                        .bold()
                        .font(.title)
                        .onTapGesture {
                            showEnterRoomNameWidget = true
                        }
                    
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
            }
            
            if showEnterRoomNameWidget {
                EnterRoomNameWidget(roomName: $roomName, isOpen: $showEnterRoomNameWidget)
            }
        }
        .background(
            Image("CardTable")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
        .onAppear {
            showEnterRoomNameWidget = true
        }
    }
}

#Preview {
    HostsRoom()
}
