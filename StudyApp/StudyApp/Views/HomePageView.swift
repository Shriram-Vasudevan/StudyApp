//
//  HomePageView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 2/8/24.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text("Welcome Shriram")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding(.leading)
                            .bold()
                        Spacer()
                        
                        Image("Roses")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .padding()
                    }
                    
                    
                    List {
                        Section(header: Text("Friends").font(.title).padding(.bottom, 10)
                            .foregroundColor(.black).listRowInsets(EdgeInsets())) {
                            Button(action: {
                                
                            }, label: {
                                HStack {
                                    Image("Roses")
                                        .resizable()
                                        .frame(width: 23, height: 23)
                                        .clipShape(Circle())
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                    
                                    Text("Robert")
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "hand.wave")
                                        .foregroundColor(.black)
                                        .padding(.trailing)
                                }
                            })
                            .listRowInsets(EdgeInsets())
                                
                            Button(action: {
                                print("hi")
                            }, label: {
                                HStack {
                                    Image("Roses")
                                        .resizable()
                                        .frame(width: 23, height: 23)
                                        .clipShape(Circle())
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                    
                                    Text("Ally")
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "hand.wave")
                                        .foregroundColor(.black)
                                        .padding(.trailing)
                                }
                            })
                            .listRowInsets(EdgeInsets())
                        
                            Button(action: {
                                
                            }, label: {
                                HStack {
                                    Image("Roses")
                                        .resizable()
                                        .frame(width: 23, height: 23)
                                        .clipShape(Circle())
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                    
                                    Text("Shriram")
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "hand.wave")
                                        .foregroundColor(.black)
                                        .padding(.trailing)
                                }
                            })
                            .listRowInsets(EdgeInsets())
                        }
                        
                    }
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                }
        
            }
        }
    }
}

#Preview {
    HomePageView()
}
