//
//  HomeView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//
import SwiftUI
import MusicKit
import Firebase
import FirebaseFirestoreSwift

struct HomeView: View {

    @AppStorage("name") var name = "ゲストユーザー"

    @State private var appleAuthStatus: MusicAuthorization.Status
    @State private var path: [NavigationLinkItem] = []

    let libraryModel = AppleMusicLibraryModel()

    init() {
        _appleAuthStatus = .init(initialValue: MusicAuthorization.currentStatus)
    }

    var body: some View {
        let bounds = UIScreen.main.bounds
        let screenHeight = Int(bounds.height)

        ZStack {
            NavigationStack(path: $path) {
                VStack {
                    Spacer()

                    Image("MusicSync_logo")
                        .resizable()
                        .scaledToFit()

                    Spacer()

                    ZStack {
                        RoundedCorners(color: .white, tl: 20, tr: 20, bl: 0, br: 0)
                            .ignoresSafeArea()
                            .frame(height: (CGFloat(screenHeight) / 1.8))

                        VStack {
                            Text("ようこそ\(name)さん")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.top, 10)

                            Text("友人家族と音楽で繋がろう")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom, 30)

                            NavigationLink(value: NavigationLinkItem.create) {
                                ButtonView(text: "ルームを作成する", textColor: .white, buttonColor: Color("color_primary"))
                            }
                            .padding(.bottom, 20)

                            NavigationLink(value: NavigationLinkItem.enter) {
                                ButtonView(text: "ルームに参加する", textColor: .black, buttonColor: Color("color_secondary"))
                            }
                            .padding(.bottom, 10)

                            Divider()

                            NavigationLink(value: NavigationLinkItem.login) {
                                Text("ログイン")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .frame(width: 300, height: 50)
                                    .background(Color("color_secondary"))
                                    .cornerRadius(10)
                            }
                            .padding(.vertical, 10)
                        }
                    }
                }
                .background {
                    Color("color_primary")
                        .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(value: NavigationLinkItem.setting) {
                            Image(systemName: "gearshape.fill")       
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    }
                }
                .navigationDestination(for: NavigationLinkItem.self) { item in
                    switch item {
                    case .create:
                        CreateGroupView(path: $path, userName: name)
                    case .enter:
                        EnterRoomPinView(path: $path)
                    case .join(let roomPin):
                        JoinGroupView(path: $path, userName: name, roomPin: roomPin)
                    case .playlist(let roomPin):
                        CreatePlaylistView(path: $path, roomPin: roomPin)
                    case .home:
                        HomeView()
                    case .setting:
                        SettingView()
                    case .login:
                        LogInView(path: $path)
                    case .passwordReset:
                        PasswordResetView(path: $path)
                    case .register:
                        EmailRegisterView(path: $path)
                    case .provision:
                        ProvisionalRegistrationView(path: $path)
                    case .licence:
                        LicenceView()
                    }
                }
            }

            if appleAuthStatus != .authorized {
                AppleMusicAuthView(appleAuthStatus: $appleAuthStatus)
            }
        }
    }
}

struct homeView_Previews: PreviewProvider {
    @State static var active = true
    static var previews: some View {
        HomeView()
    }
}
