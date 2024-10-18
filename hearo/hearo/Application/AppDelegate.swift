//
//  AppDelegate.swift
//  hearo
//
//  Created by 규북 on 10/18/24.
//

import WatchConnectivity

class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    if WCSession.default.activationState == .notActivated {
      WCSession.default.delegate = self
      WCSession.default.activate()
    }
    return true
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) {}
  func sessionDidDeactivate(_ session: WCSession) {}
  func sessionWatchStateDidChange(_ session: WCSession) {}
}
