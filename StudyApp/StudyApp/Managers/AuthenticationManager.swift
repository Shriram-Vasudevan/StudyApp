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
import FirebaseStorage
import SwiftUI

class AuthenticationManager : ObservableObject {
    func isUserSignedIn() -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            return false
        }

        do {
            let _ = currentUser.getIDTokenForcingRefresh(true)
            print("ID Token is valid. User exists: \(currentUser.uid)")
            return true
        } catch {
            print("Error fetching ID token: \(error)")
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error signing out: \(error)")
            }
            return false
        }
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
    
    func signUp(email: String, password: String, name: String, pfpData: Data, completionHandler: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
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
            
            self.saveProfilePictureLocally(pfpData: pfpData, userID: user.uid)
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
    
    func uploadProfilePicture(userID: String) async {
        print(userID)
        let storage = Storage.storage()
        let storageRef = storage.reference()
    
        if await pfpUploaded(userID: userID) {
            print("uploaded")
            return
        }
        else {
            guard let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let pfpUrl = directoryUrl.appendingPathComponent("pfp-\(userID).png", isDirectory: false)
            if FileManager.default.fileExists(atPath: pfpUrl.path) {
                guard let pfpData = FileManager.default.contents(atPath: pfpUrl.path) else { 
                    print("data exists")
                    return
                }
                
                let storageRefChild = storageRef.child("ProfilePictures/\(userID).jpg")
                let uploadTask = storageRefChild.putData(pfpData, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        return
                    }
                    
                    let size = metadata.size
                    
                    storageRef.downloadURL { (url, error) in
                        print(error)
                        guard let downloadURL = url else {
                            print("url did not work")
                            return
                        }
                        
                        let imageURL = downloadURL.absoluteString
                        
                        print(imageURL)
                    }
                }
                
            }
            else {
                print("no file")
                return
            }
        }

    }
    
    func pfpUploaded(userID: String) async -> Bool {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        do {
            let pfp = try await storageRef.child("ProfilePictures/\(userID).jpg").data(maxSize: 4096 * 4096)
            return true
        } catch {
            return false
        }
   }
    
    func saveProfilePictureLocally(pfpData: Data, userID: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let pfpURL = documentsDirectory.appendingPathComponent("pfp-\(userID).png", isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: pfpURL.path) {
            do {
                try pfpData.write(to: pfpURL)
            } catch {
                print("local pfp error: " + error.localizedDescription)
            }
        }
    }
}
