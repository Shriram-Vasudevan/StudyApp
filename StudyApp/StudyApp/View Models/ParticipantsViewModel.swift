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

class ParticipantsViewModel: ObservableObject {
    @Published var roomModel: RoomModel
    
    init(roomModel: RoomModel) {
        self.roomModel = roomModel
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
                    let roomModel = try document.data(as: RoomModel.self)
                    self.roomModel = roomModel
                } catch {
                    return
                }
          }
    }
}
