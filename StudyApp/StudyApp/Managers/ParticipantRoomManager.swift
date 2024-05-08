//
//  ParticipantRoomManager.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/21/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import AVKit

class ParticipantRoomManager: ObservableObject {
    @Published var roomModel: RoomModel {
        didSet {
            checkForMusicChange(oldModel: oldValue, newModel: roomModel)
        }
    }
    @Published var musicOn = true
    
    var avAudioPlayer: AVAudioPlayer?
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init(roomModel: RoomModel) {
        self.roomModel = roomModel
    }
    
    func checkForMusicChange(oldModel: RoomModel, newModel: RoomModel) {
        if oldModel.music != newModel.music && musicOn {
            changeMusic()
        }
    }
    
    func setupAVAudioPlayer() {
        if let sound = Bundle.main.url(forResource: roomModel.music, withExtension: "mp3") {
            do {
                self.avAudioPlayer = try AVAudioPlayer(contentsOf: sound)
            } catch {
                print("AVPlayer Error")
            }
        }
        else {
            print("Music does not exist")
        }
    }
    
    func changeMusic() {
        musicOn = true
        setupAVAudioPlayer()
        avAudioPlayer?.play()
        avAudioPlayer?.numberOfLoops = -1
    }
    
    func pauseMusic() {
        self.avAudioPlayer?.pause()
        musicOn = false
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
                } catch {
                    print(error.localizedDescription)
                    return
                }
          }
    }
}
