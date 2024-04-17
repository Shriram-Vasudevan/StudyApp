//
//  ChatView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/9/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var messageManager: MessageManager
    @State private var message: String = ""
    
    var roomID: String
    var roomBackground: String
    
    let customGrey: Color = Color(red: 248/255.0, green: 252/255.0, blue: 252/255.0)
    let customBlue = Color(red: 32/255.0, green: 116/255.0, blue: 252/255.0)
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Chat")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                ScrollView {
                    ForEach(messageManager.messages, id: \.id) { message in
                        ChatBubble(message: message)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                }
                .padding(.top)
                
                Spacer()

                HStack(spacing: 10) {
                    TextField("Enter a message...", text: $message)
                        .padding(12)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(white: 1, opacity: 0.3), lineWidth: 1)
                        )
                        .overlay(
                            Button(action: {
                                messageManager.sendMessage(message: message, roomID: roomID)
                                message = ""
                            }, label: {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.purple)
                                    .padding(.trailing, 5)
                            }),
                            alignment: .trailing
                        )
                }
                .padding([.leading, .trailing, .bottom], 12)
            }
        }
        .background(
            Image(roomBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    ChatView(messageManager: MessageManager(), roomID: "", roomBackground: "Jungle")
}
