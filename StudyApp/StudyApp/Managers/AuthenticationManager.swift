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
            return
        }
        else {
            guard let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let pfpUrl = directoryUrl.appendingPathComponent("pfp-\(userID).png", isDirectory: false)
            if FileManager.default.fileExists(atPath: pfpUrl.path) {
                guard let pfpData = FileManager.default.contents(atPath: pfpUrl.path) else { return
                }
                
                let storageRefChild = storageRef.child("ProfilePictures/\(userID).jpg")
                let uploadTask = storageRefChild.putData(pfpData, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        return
                    }
                    
                    let size = metadata.size
                    
                    storageRef.downloadURL { (url, error) in
                        
                        guard let downloadURL = url else {
                            return
                        }
                        
                        let imageURL = downloadURL.absoluteString
                    }
                }
                
            }
            else {
                return
            }
        }

    }
    
    func pfpUploaded(userID: String) async -> Bool {
//       do {
//           let options = StorageListRequest.Options(path: "pfp-media/\(userID).png", pageSize: 1)
//           let listResult = try await Amplify.Storage.list(options: options)
//           return listResult.items.count > 0
//       } catch {
//           print(error.localizedDescription)
//           return false
//       }
        
        return true
   }
    
    func saveProfilePictureLocally(pfpData: Data, userID: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let pfpURL = documentsDirectory.appendingPathComponent("pfp-\(userID).png", isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: pfpURL.path) {
            do {
                try pfpData.write(to: pfpURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
