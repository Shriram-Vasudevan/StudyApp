//
//  ParticipantsViewModel.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/7/24.
//

import Foundation

class ParticipantsViewModel: ObservableObject {
    @Published var roomModel: RoomModel
    
    init(roomModel: RoomModel) {
        self.roomModel = roomModel
    }

    func listenForRoomUpdates() {
        
    }
}
