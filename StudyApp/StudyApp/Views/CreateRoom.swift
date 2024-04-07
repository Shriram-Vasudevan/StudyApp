//
//  CreateRoom.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/6/24.
//

import SwiftUI

struct CreateRoom: View {
    var body: some View {
        ZStack {
            Color.black
            VStack {
                HStack {
                    Spacer()
                    
                    Text("Create Room")
                        .foregroundColor(.black)
                        .bold()
                        .font(.headline)
                    
                    Spacer()
                }
            }
            .padding()
            .frame(width: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            .padding()
        }
    }
}

#Preview {
    CreateRoom()
}
