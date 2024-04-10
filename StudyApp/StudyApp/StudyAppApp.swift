//
//  StudyAppApp.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/6/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()

      return true
  }
}

@main
struct StudyAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authenticationManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            if authenticationManager.isUserSignedIn() {
                PagesHolderView(pageType: .main)
                    .preferredColorScheme(.light)
            } else {
                PagesHolderView(pageType: .authentication)
                    .preferredColorScheme(.light)
            }
        }
    }
}
