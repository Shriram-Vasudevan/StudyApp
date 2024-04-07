//
//  Home.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/6/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Hello Shriram")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        )
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                
                Spacer()
                
                VStack {
                    Text("Create Room")
                        .foregroundColor(.black)
                        .bold()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                )
                
                Spacer()
                
                VStack {
                    Text("Join Room")
                        .foregroundColor(.black)
                        .bold()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                )
                
                Spacer()
            }
        }
        .background(
            Image("CardTable")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    Home()
}
