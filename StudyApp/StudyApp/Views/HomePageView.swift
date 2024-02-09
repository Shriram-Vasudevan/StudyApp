//
//  HomePageView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 2/8/24.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Welcome Shriram")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.leading)
                    Spacer()
                    
                    Image("Roses")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding()
                }
                
                Spacer()
            }
    
        }
        
    }
}

#Preview {
    HomePageView()
}
