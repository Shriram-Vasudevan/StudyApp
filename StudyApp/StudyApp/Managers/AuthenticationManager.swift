//
//  AuthenticationManager.swift
//  Study App
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AuthenticationManager : ObservableObject {
    
    func signInAnonymously(completionHandler: @escaping () -> Void) {
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let user = authResult?.user else {
                print("Anonymous sign-in failed: \(error?.localizedDescription ?? "No error information")")
                return
            }
            let isAnonymous = user.isAnonymous
            let uid = user.uid
            print("Signed in anonymously with uid: \(uid)")
            completionHandler()
        }
    }
    
    func signUp(email: String, password: String, completionHandler: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Sign up failed: \(error.localizedDescription)")
                return
            }
            
            completionHandler()
        }
    }
    
    func signIn(email: String, password: String, completionHandler: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
        
            if let error = error {
                print("Sign in failed: \(error.localizedDescription)")
                return
            }
            
            completionHandler()
        }
    }
}
