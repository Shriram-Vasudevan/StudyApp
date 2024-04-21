//
//  RegisterView.swift
//  Study App
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI
import PhotosUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var selectedProfilePicture: [PhotosPickerItem] = []
    @State private var pfpData: Data?
    
    @State var emailUnfilled: Bool = false
    @State var nameUnfilled: Bool = false
    @State var passwordUnfilled: Bool = false
    @State var confirmPasswordUnfilled: Bool = false
    @State var passwordsDontMatch: Bool = false
    
    @Environment(\.dismiss) var dismiss

    @ObservedObject var authenticationManager: AuthenticationManager
    
    var customGrey: Color = Color(red: 248/255.0, green: 252/255.0, blue: 252/255.0)
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
                                )
                        })
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    PhotosPicker(selection: $selectedProfilePicture, maxSelectionCount: 1, matching: .images) {
                        if let pfpData = pfpData {
                            Image(uiImage: UIImage(data: pfpData)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 175, height: 175)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        else {
                            Image("JungleLake")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 175, height: 175)
                                .clipShape(Circle())
                                .overlay(
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                        .padding(5),
                                    alignment: .bottom
                                )
                                .shadow(radius: 10)
                        }
                    }
                    .onChange(of: selectedProfilePicture) { newValue in
                        guard let image = selectedProfilePicture.first else {
                            return
                        }
                        
                        Task {
                            if let data = try? await  image.loadTransferable(type: Data.self) {
                                pfpData = data
                            }
                        }
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Text("Create Account!")
                            .foregroundColor(.black)
                            .font(.custom("Sailec Bold", size: 30))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                    CustomTextField(placeholder: Text("First Name").foregroundColor(.gray), text: $name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(nameUnfilled ? .red.opacity(0.7) : customGrey))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(nameUnfilled ? .red : .gray.opacity(0.3), lineWidth: 1))
                        .padding(.horizontal, 20)
                        .autocapitalization(.none)
                        .padding(.bottom, 15)
             
                    CustomTextField(placeholder: Text("Email").foregroundColor(.gray), text: $email)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(emailUnfilled ? .red.opacity(0.7) : customGrey))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(emailUnfilled ? .red : .gray.opacity(0.3), lineWidth: 1))
                        .padding(.horizontal, 20)
                        .autocapitalization(.none)
                        .padding(.bottom, 15)

               
                    CustomSecureField(placeholder: Text("Password").foregroundColor(.gray), text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(passwordUnfilled ? .red.opacity(0.7) : customGrey))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(passwordUnfilled ? .red : .gray.opacity(0.3), lineWidth: 1))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                    
                
                    CustomSecureField(placeholder: Text("Confirm Password").foregroundColor(.gray), text: $confirmPassword)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(confirmPasswordUnfilled ? .red.opacity(0.7) : customGrey))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(confirmPasswordUnfilled ? .red : .gray.opacity(0.3), lineWidth: 1))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                    
                    if passwordsDontMatch {
                        HStack {
                            Text("Passwords don't Match!")
                                .font(.headline)
                                .fontWeight(.bold)
                                .bold()
                                .foregroundColor(Color.red)
                                .padding(.leading, 20)
                           
                            
                            Spacer()
                        }
                    }
                  
                    Button(action: {
                        withAnimation {
                            checkFieldsAndSignUp()
                        }
                    }) {
                        Text("Register")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(20)
                            .background(.black)
                            .cornerRadius(7)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 15)
                    
                }
            }
            
            VStack {
                Spacer()
                
                VStack {
                    HStack {
                        Text("Already have an account?")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .bold()
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Sign In")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .bold()
                                .foregroundColor(Color.blue)
                        }
                    }
                    .padding(.top, 20)
                    
                    Text("By signing up, you agree to our Terms and Conditions.")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .bold()
                        .padding(.top, 5)
                }
                .padding()
                .background(
                    .white
                )
            }
            
        }
        .navigationBarBackButtonHidden()
    }
    
    func checkFieldsAndSignUp() {
        emailUnfilled = email.isEmpty
        nameUnfilled = name.isEmpty
        passwordUnfilled = password.isEmpty
        confirmPasswordUnfilled = confirmPassword.isEmpty
        

        
        passwordsDontMatch = confirmPasswordUnfilled || passwordUnfilled ? false :  password != confirmPassword
        
        if (!emailUnfilled && !nameUnfilled && !passwordUnfilled && !confirmPasswordUnfilled && !passwordsDontMatch), let pfpData = self.pfpData {
            authenticationManager.signUp(email: email, password: password, name: name, pfpData: pfpData, completionHandler: {
                    dismiss()
            })
        }
    }
}


#Preview {
    RegisterView(authenticationManager: AuthenticationManager())
}
