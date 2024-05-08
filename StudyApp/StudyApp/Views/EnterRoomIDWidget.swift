//
//  EnterRoomIDWidget.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI

struct EnterRoomIDWidget: View {
    var homeViewModel: HomeViewModel
    
    @State var roomID: String = ""
    @Binding var isOpen: Bool
    
    var joinedRoom: (RoomModel) -> Void
    
    @State var offset: CGFloat = 1000
    
    let customGrey: Color = Color(red: 230/255.0, green: 230/255.0, blue: 230/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .onTapGesture {
                    print("tapped outside")
                    withAnimation (.spring()){
                        offset = 1000
                        
                        isOpen = false
                    }
                }
                .ignoresSafeArea()
            
            
            VStack {
                HStack {
                    Text("Enter a Room Code")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                
                TextField("Enter Code", text: $roomID)
                    .padding()
                    .autocapitalization(.none)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(customGrey.opacity(0.7))
                    )
                
                Button {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        Task {
                            if await homeViewModel.roomExists(roomID: roomID) {
                                print("exists")
                                do {
                                    let roomModel = try await homeViewModel.joinRoom(roomID: roomID)
                                    joinedRoom(roomModel)
                                    
                                    withAnimation (.spring()){
                                        offset = 1000
                                        
                                        isOpen = false
                                    }
                                } catch {
                                    print("failed")
                                    //nothing for now
                                }
                            }
                            else {
                                print("not exists")
                                //for now nothing
                            }
                        }
                    }
                } label: {
                    Text("Join")
                        .foregroundColor(.white)
                        .font(.headline)
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.top)
                }

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
    EnterRoomIDWidget(homeViewModel: HomeViewModel(), isOpen: .constant(true), joinedRoom: { _ in print("Enter Room") })
}
