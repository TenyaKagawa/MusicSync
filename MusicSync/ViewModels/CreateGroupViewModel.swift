//
//  CreateGroupViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Combine
import MusicKit
import Firebase
import FirebaseFirestoreSwift

@MainActor
class CreateGroupViewModel: ObservableObject {
    var storeModel = FirestoreModelAsync()
    var musicModel = AppleMusicLibraryModel()
    var authModel = FirebaseAuthModel()
    var db = Firestore.firestore()

    var songs = MusicItemCollection<Song>()
    
    @Published var usersData: [UserData]
    @Published var isLoading = true
    @Published var isError = false
    @Published var roomPin = 000000
    @Published var nextFlag = false
    @State private var listener: ListenerRegistration?

    init(usersData: [UserData] = [UserData](),
         model: FirestoreModelAsync = FirestoreModelAsync(),
         musicModel: AppleMusicLibraryModel = AppleMusicLibraryModel()) {
        self.usersData = usersData
        self.storeModel = model
        self.musicModel = musicModel
    }

    func addListener(roomPin: String) {
        listener = db.collection("Room").document(roomPin).collection("Member")
            .addSnapshotListener { (querySnapshot, error) in
                guard let document = querySnapshot?.documents else {
                    print("Error fetching document: \(error!)")
                    return
                }
                self.usersData = document.map { (queryDocumentSnapshot) -> UserData in
                    let data = queryDocumentSnapshot.data()
                    let name = data["name"] as? String ?? ""
                    let id = data["id"] as? String ?? "000000"
                    return UserData(id: id, name: name)
                }
            }
    }

    func removeListener() {
        listener?.remove()
    }

    func createGroup(userName: String) {
        Task {
            do {
                if Auth.auth().currentUser == nil {
                    try await authModel.loginAsGuestAsync()
                }
                songs = try await musicModel.loadLibraryAsync(limit: 0)
                roomPin = try await self.storeModel.createRoom(host: userName)
                try self.storeModel.uploadSongs(item: songs)
                self.addListener(roomPin: String(roomPin))
                self.isLoading = false
            } catch {
                print("error:\(error.localizedDescription)")
                self.isError = true
            }
        }
    }
    
    func pushNext() {
        self.nextFlag = true
        Task {
            do {
                try await storeModel.pushNext(roomPin: String(roomPin))
            } catch {
                self.isError = true
            }
        }
    }

    func deleteGroup() {
        storeModel.deleteRoom(roomPin: String(roomPin))
    }

}
