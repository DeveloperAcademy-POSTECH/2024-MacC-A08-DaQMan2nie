//
//  AppDelegate.swift
//  hearo
//
//  Created by 규북 on 10/18/24.
//
import UIKit
import WatchConnectivity

class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // WCSession 활성화
        if WCSession.default.activationState == .notActivated {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        return true
    }

    // 필수 메서드: 활성화 상태 변경시 호출됨
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession 활성화 오류: \(error.localizedDescription)")
        } else {
            print("WCSession 활성화 성공, 상태: \(activationState)")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    func sessionWatchStateDidChange(_ session: WCSession) {}
}
