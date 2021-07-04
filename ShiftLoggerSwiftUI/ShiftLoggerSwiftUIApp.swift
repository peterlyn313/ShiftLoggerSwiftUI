//
//  ShiftLoggerSwiftUIApp.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/13/21.
//

import SwiftUI

@main
struct ShiftLoggerSwiftUIApp: App {
    @StateObject var loginVM: LoginViewModel = LoginViewModel()
    @StateObject var mainVM: MainViewModel = MainViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                LoginView()
            }.environmentObject(loginVM)
            .environmentObject(mainVM)
           
        }
    }
}
