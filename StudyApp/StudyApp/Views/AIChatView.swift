//
//  AIChatView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/25/24.
//

import SwiftUI

struct AIChatView: View {
    @ObservedObject var AIManager: AIManager
    
    @State private var message: String = ""
    @FocusState private var chatFieldIsFocused: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Image("Kevin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .padding(.bottom, 5)
                
                Text("I'm Kevin, an AI Educational Assistant")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(width: 175)
                
                Spacer()
            }
            
            VStack {
                ScrollView {
                    ForEach(AIManager.messages, id: \.id) { message in
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
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 1)
                        )
                        .overlay(
                            Button(action: {
                                chatFieldIsFocused = false
                                AIManager.askQuestion(prompt: message)
                                message = ""
                            }, label: {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.purple)
                                    .padding(.trailing, 5)
                            }),
                            alignment: .trailing
                        )
                        .focused($chatFieldIsFocused)
                }
                .padding([.leading, .trailing, .bottom], 12)

            }
        }
    }
}

#Preview {
    AIChatView(AIManager: AIManager())
}
