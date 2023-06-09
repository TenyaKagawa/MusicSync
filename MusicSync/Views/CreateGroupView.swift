//
//  CreateGroupView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import MusicKit

struct CreateGroupView: View {
    
    @StateObject var viewModel = CreateGroupViewModel()
    @State var listener: ListenerRegistration?
    @State private var isActive = false
    @Binding var isTitleViewActive: Bool
    
    var name: String
    
    var body: some View {
        
        ZStack{
            VStack{
                ProgressView("ユーザーを待機中")
                    .font(.title2)
                    .padding(.top, 50)
                
                
                List(viewModel.usersData){ userdata in
                    Text(userdata.name)
                }
                .onAppear {
                    LoadingControl.shared.showLoading()
                    viewModel.createGroup(userName: name) { Listener, roomPin  in
                        listener = Listener
                        viewModel.pubRoomPin = roomPin
                    }
                }
                
                Text("room Pin:\(viewModel.pubRoomPin)")
                    .font(.title)
                    .padding(30)
                
                
                
                NavigationLink(destination: CreatePlaylistView(isTitleViewActive: $isTitleViewActive, roomPin: viewModel.pubRoomPin, usersData: viewModel.usersData),
                               isActive: $isActive){
                    Button {
                        self.isActive = true
                    } label: {
                        ButtonView(text: "プレイリストを作成する", buttonColor: .blue)
                    }
                }
                .isDetailLink(false)
                //.disabled(viewModel.usersData.count <= 1)
                .padding()
                
                
                Spacer()
            }
            
            if LoadingControl.shared.isLoading { LoadingView() }
            
        }
       
        .onDisappear {
            if let listener = listener {
                listener.remove()
            }
            
            viewModel.exitGroup(roomPin: viewModel.pubRoomPin)
        }
    }
}

struct createGroupView_Previews: PreviewProvider {
    @State static var state = true
    static var previews: some View {
        CreateGroupView(isTitleViewActive: $state , name: "preuser")
    }
}
