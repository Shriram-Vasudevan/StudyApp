//
//  RegisterView.swift
//  Study App
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import SwiftUI

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
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
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom, 40)

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
                        .padding(.bottom, 20)
                }

            }
            .background(
                Image("NJLandscape")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .scaleEffect(x: -1, y: 1)
            )
        }
        .navigationBarBackButtonHidden()
    }
    
    func checkFieldsAndSignUp() {
        emailUnfilled = email.isEmpty
        nameUnfilled = name.isEmpty
        passwordUnfilled = password.isEmpty
        confirmPasswordUnfilled = confirmPassword.isEmpty
        

        
        passwordsDontMatch = confirmPasswordUnfilled || passwordUnfilled ? false :  password != confirmPassword
        
        if (!emailUnfilled && !nameUnfilled && !passwordUnfilled && !confirmPasswordUnfilled && !passwordsDontMatch) {
            authenticationManager.signUp(email: email, password: password, name: name, completionHandler: {
                    dismiss()
            })
        }
    }
}


#Preview {
    RegisterView(authenticationManager: AuthenticationManager())
}
