//
//  JoinGroupView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

import SwiftUI

struct JoinGroupView: View {
    @State private var roomPin:String = ""
    @State private var isActive = false
    @Binding var isTitleViewActive: Bool
    @StateObject var viewModel = JoinGroupViewModel()
    
    var name: String
    
    var body: some View {
      
            VStack{
                TextField("roomPinを入力", text: $roomPin)
                    .keyboardType(.numberPad)
                    .autocapitalization(.none)
                    .font(.system(size: 35))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(.red,lineWidth: 3)
                    )
                    .padding(40)
                
                    
                NavigationLink(destination: AfterJoinView(isTitleViewActive: $isTitleViewActive, name: name, roomPin: roomPin),
                               isActive: $isActive){
                    Button {
                        self.isActive = true
                    } label: {
                        ButtonView(text: "グループに参加", buttonColor: roomPin.count != 6 ? .gray : .blue)
                    }
                }
                .isDetailLink(false)
                .disabled(roomPin.count != 6)
                .padding(40)
            }
    }
}

struct joinGroupView_Previews: PreviewProvider {
    @State static var state = true
    static var previews: some View {
        JoinGroupView(isTitleViewActive: $state, name: "testUser")
    }
}
