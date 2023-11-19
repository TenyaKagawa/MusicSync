//
//  ButtonView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct ButtonView: View {
    var text: String
    var textColor: Color = .white
    var buttonColor: Color

    var body: some View {
        ZStack {
            Text(text)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(textColor)
                .frame(width: 300, height: 50)
                .background(buttonColor)
                .cornerRadius(10)
        }

    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "ボタン", textColor: .white, buttonColor: Color("color_primary"))
    }
}
