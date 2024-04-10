//
//  ChatBubble.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/9/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ChatBubble: View {
    var message: Message
    
    var body: some View {
        HStack {
            if message.senderID == Auth.auth().currentUser?.uid {
                Spacer()
                VStack (alignment: .trailing) {
                    Text(message.message)
                        .padding(10)
                        .background(Color.purple)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    
                    Text(message.senderName)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } else {
                VStack (alignment: .leading) {
                    Text(message.message)
                        .padding(10)
                        .background(Color.blue.opacity(0.6))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    
                    Text(message.senderName)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    ChatBubble(message: Message(id: "", message: "Hello", senderID: "", senderName: "David", timestamp: Date()))
}
