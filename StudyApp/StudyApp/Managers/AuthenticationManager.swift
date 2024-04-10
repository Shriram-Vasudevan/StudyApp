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
    
    func isUserSignedIn() -> Bool {
        guard let currentUser = Auth.auth().currentUser else { return false }
        
        print("user exists: \(currentUser.uid)")
        
        return true
    }
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
    
    func signUp(email: String, password: String, name: String, completionHandler: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Sign up failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else {
                print("User was not created.")
                return
            }
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Error updating display name: \(error.localizedDescription)")
                } else {
                    print("User display name updated to: \(name)")
                }
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
    
    func signOut(completionHandler: @escaping () -> Void) {
        do {
            guard let currentUser = Auth.auth().currentUser else { return }
            
            try Auth.auth().signOut()
            
            completionHandler()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
