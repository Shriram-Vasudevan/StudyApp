//
//  PickBackgroundView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/21/24.
//

import SwiftUI

struct PickBackgroundView: View {
    @ObservedObject var hostRoomManager: HostRoomManager
    
    @State var offset: CGFloat = 1000
    @Binding var isOpen: Bool
    
    let columns: [GridItem] = [GridItem(.fixed(70)), GridItem(.fixed(70)), GridItem(.fixed(70))]
    let images: [String] = ["JungleLake", "LakeMountainMarsh", "Mountains", "JungleBridge"]
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    close()
                }
            
            VStack {
                LazyVGrid(columns: columns, spacing: 20, content: {
                    ForEach(images, id: \.self) { image in
                        backgroundImageWidget(image: image)
                            .onTapGesture {
                                Task {
                                    await hostRoomManager.changeBackgroundImage(image: image)
                                    close()
                                }
                            }
                    }
                })
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(width: 270)
            )
            .padding()
            .onAppear {
                withAnimation(.bouncy()) {
                    offset = 0
                }
            }
            .offset(x: 0, y: offset)
        }
    }
    
    func close() {
        withAnimation (.spring()){
            offset = 1000
            
            isOpen = false
        }
    }
}

struct backgroundImageWidget: View {
    var image: String
    
    var body: some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .clipped()
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2)
            }
    }
}

#Preview {
    PickBackgroundView(hostRoomManager: HostRoomManager(roomModel: RoomModel(id: "", host: "", roomName: "", roomMembers: [], backgroundImage: "JungleLake")), isOpen: .constant(true))
}
