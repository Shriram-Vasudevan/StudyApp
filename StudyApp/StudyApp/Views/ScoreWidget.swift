//
//  ScoreWidget.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/14/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ScoreWidget: View {
    var roomMember: RoomMember
    
    var body: some View {
        if roomMember.userID == Auth.auth().currentUser?.uid {
            HStack {
                Text(roomMember.displayName)
                    .font(.headline)
                    .foregroundColor(.black)
                    .bold()
                
                Spacer()
                
                
                Text("\(roomMember.score)")
                    .font(.headline)
                    .foregroundColor(.black)
                    .bold()
            }
            .padding(.vertical)
            .background(
                Rectangle()
                    .fill(.white)
            )
        } else {
            HStack {
                Text(roomMember.displayName)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                
                Text("\(roomMember.score)")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding(.vertical)
            .background(
                Rectangle()
                    .fill(.white)
            )
        }
    }
}

#Preview {
    ScoreWidget(roomMember: RoomMember(userID: "", displayName: "", score: 100))
}
