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

class HostsRoomViewModel: ObservableObject {
    @Published var roomModel: RoomModel
    
    init(roomModel: RoomModel) {
        self.roomModel = roomModel
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
        
    }
}
