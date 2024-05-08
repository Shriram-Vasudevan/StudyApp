//
//  HostRoomManager.swift
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

class HostRoomManager: ObservableObject {
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
            changeAVPlayerMusic()
        }
    }
    
    func setupAVAudioPlayer() {
        print("playing")
        if let sound = Bundle.main.url(forResource: self.roomModel.music, withExtension: "mp3") {
            do {
                avAudioPlayer = try AVAudioPlayer(contentsOf: sound)
            } catch {
                print("AV Player Error")
            }
        }
        else {
            print("Audio File not found")
        }
    }
    
    func changeAVPlayerMusic() {
        musicOn = true
        setupAVAudioPlayer()
        self.avAudioPlayer?.play()
        avAudioPlayer?.numberOfLoops = -1
    }
    
    func pauseMusic() {
        self.avAudioPlayer?.pause()
        musicOn = false
    }
    
    func closeRoom() {
        guard let user = Auth.auth().currentUser, let roomID = roomModel.id, let userDisplayName = user.displayName else { return }
        
        db.collection("Rooms").document(roomID).delete()
    }
    
    func changeBackgroundImage(image: String) async {
        do {
            DispatchQueue.main.async {
                self.roomModel.backgroundImage = image
            }
            
            guard let roomID = roomModel.id else { return }
            
            try await db.collection("Rooms").document(roomID).updateData(
                [
                    "backgroundImage" : image
                ]
            )
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func changeMusic(music: String) async {
        do {
            DispatchQueue.main.async {
                self.roomModel.music = music
            }

            guard let roomID = roomModel.id else { return }
            
            try await db.collection("Rooms").document(roomID).updateData(
                [
                    "music" : music
                ]
            )
            
        } catch {
            print(error.localizedDescription)
        }
    }
    func updateRoomName(roomName: String) async {
        do {
            DispatchQueue.main.async {
                self.roomModel.roomName = roomName
            }
            
            guard let roomID = roomModel.id else { return }
            
            try await db.collection("Rooms").document(roomID).updateData(
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
                    
                    self.roomModel = RoomModel(id: updatedRoomModel.id, host: updatedRoomModel.host, roomName: updatedRoomModel.roomName, roomMembers: updatedRoomModel.roomMembers, backgroundImage: updatedRoomModel.backgroundImage, music: updatedRoomModel.music)
                    
//                    print("worked")
                    print(self.roomModel.roomMembers)
                } catch {
                    print(error.localizedDescription)
                    return
                }
          }
    }
    
}

enum RoomEntryError: Error {
    case dataRetrievalFailed
}
enum AuthError: Error {
    case noUser, creationFailed
}
