//
//  Home.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/6/24.
//

import SwiftUI

struct Home: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    @State var navigateToHostRoom: Bool = false
    
    var body: some View {
        NavigationStack {
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
                    
                    Button(action: {
                        Task {
                            do {
                                try await homeViewModel.createRoom()
                                
                                navigateToHostRoom = true
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }, label: {
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
                    })
                    
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
            .navigationDestination(isPresented: $navigateToHostRoom, destination: {
                HostsRoom()
            })
            .background(
                Image("CardTable")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    Home()
}
