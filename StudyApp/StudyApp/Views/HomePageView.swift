//
//  HomePageView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 2/8/24.
//

import SwiftUI

struct HomePageView: View {
    @State var roomCode: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
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
                    
                    HStack {
                        Text("Friends").font(.title).padding(.bottom, 10)
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        Spacer()
                    }
                    
                    VStack {
                        Button(action: {
                            
                        }, label: {
                            HStack {
                                Image("Roses")
                                    .resizable()
                                    .frame(width: 23, height: 23)
                                    .clipShape(Circle())
                                    .foregroundColor(.black)
                       
                                
                                Text("Robert")
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "hand.wave")
                                    .foregroundColor(.black)
              
                            }
                        })
   
                        Divider()
                            .padding(.leading)
                        Button(action: {
                            print("hi")
                        }, label: {
                            HStack {
                                Image("Roses")
                                    .resizable()
                                    .frame(width: 23, height: 23)
                                    .clipShape(Circle())
                                    .foregroundColor(.black)
                                
                                Text("Ally")
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "hand.wave")
                                    .foregroundColor(.black)
                            }
                        })
             
                        Divider()
                            .padding(.leading)
                        
                        Button(action: {
                            
                        }, label: {
                            HStack {
                                Image("Roses")
                                    .resizable()
                                    .frame(width: 23, height: 23)
                                    .clipShape(Circle())
                                    .foregroundColor(.black)

                                
                                Text("Shriram")
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "hand.wave")
                                    .foregroundColor(.black)
                            }
                        })
                   
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 13)
                            .fill(.white)
                    )
                    .padding()
                    
                    VStack {
                        Text("Create Room")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .bold()
                        
                        Text("Create")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .bold()
                            .font(.headline)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.green)
                                    .shadow(radius: 5)
                            )
                            .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(colors: [.black.opacity(0.3),.black], startPoint: .top, endPoint: .bottom))
                    )
                    .padding()
                    
                    
                    VStack {
                        Text("Have A Room Code?")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .bold()
                        
                        TextField("", text: $roomCode)
                            .placeholder(when: roomCode.isEmpty, placeholder: {
                                Text("Code").foregroundColor(.white.opacity(0.7))
                            })
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                            )
                            .padding(.vertical)
                        
                        Text("Join")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .bold()
                            .font(.headline)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.blue)
                                    .shadow(radius: 5)
                            )
                            .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(colors: [.black.opacity(0.3),.black], startPoint: .top, endPoint: .bottom))
                    )
                    .padding()
                    Spacer()
                }
        
            }
        }
    }
}

#Preview {
    HomePageView()
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
