//
//  HostsRoomViewModel.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class HostsRoomViewModel: ObservableObject {
    @Published var roomModel: RoomModel
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init(roomModel: RoomModel) {
        self.roomModel = roomModel
    }
    
    func closeRoom() {
        guard let user = Auth.auth().currentUser, let roomID = roomModel.id, let userDisplayName = user.displayName else { return }
        
        db.collection("Rooms").document(roomID).delete()
    }
    
    func updateRoomName(roomName: String) async {
        do {
            DispatchQueue.main.async {
                self.roomModel.roomName = roomName
            }
            
            guard let roomID = roomModel.id else { return }
            let dbRef = Firestore.firestore()
            
            try await dbRef.collection("Rooms").document(roomID).updateData(
                [
                    "roomName" : roomName
                ]
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func listenForRoomUpdates() {
        guard let roomID = roomModel.id else { return }
        let dbReference = Firestore.firestore()
        
        dbReference.collection("Rooms").document(roomID)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
                print("\(source) data: \(document.data() ?? [:])")
                
                do {
                    let updatedRoomModel = try document.data(as: RoomModel.self)
                    print(updatedRoomModel)
                    DispatchQueue.main.async {
                        self.roomModel = updatedRoomModel
                        print(self.roomModel)
                    }
                    
//                    print("worked")
//                    print(self.roomModel.roomMembers)
                } catch {
                    print(error.localizedDescription)
                    return
                }
          }
    }
    
}
