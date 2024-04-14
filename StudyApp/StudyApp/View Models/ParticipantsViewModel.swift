//
//  ParticipantsViewModel.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ParticipantsViewModel: ObservableObject {
    @Published var roomModel: RoomModel
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init(roomModel: RoomModel) {
        self.roomModel = roomModel
    }

    func leaveRoom() async {
        do {
            guard let user = Auth.auth().currentUser, let roomID = roomModel.id, let userDisplayName = user.displayName else { return }
            
            try await db.collection("Rooms").document(roomID).updateData(
                [
                    "roomMembers" : FieldValue.arrayRemove(["\(user.uid)-\(userDisplayName)"])
                ]
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func listenForRoomUpdates() {
        guard let roomID = roomModel.id else { return }
        
        db.collection("Rooms").document(roomID)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
                print("\(source) data: \(document.data() ?? [:])")
                
                do {
                    let roomModel = try document.data(as: RoomModel.self)
                    self.roomModel = roomModel
                } catch {
                    return
                }
          }
    }
    

}
