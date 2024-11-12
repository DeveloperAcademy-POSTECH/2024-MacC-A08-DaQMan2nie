//
//  WatchSessionManager.swift
//  HearoadWatch Watch App
//
//  Created by Pil_Gaaang on 10/28/24.
//
import Foundation
import WatchKit
import WatchConnectivity

class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchSessionManager()

    @Published var alertMessage: String = "인식중"
    @Published var isAlerting: Bool = false

    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func alertImageName() -> String {
        switch alertMessage {
        case "Carhorn":
            return "Car"
        case "Siren":
            return "Siren"
        case "Bicyclebell":
            return "Bicycle"
        default:
            return "issue"
        }
    }

    // iOS에서 sendMessage로 데이터 수신
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let alert = message["alert"] as? String {
            DispatchQueue.main.async {
                self.showAlert(with: alert)
            }
        }
    }

    // iOS에서 updateApplicationContext로 데이터 수신
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let alert = applicationContext["alert"] as? String {
            DispatchQueue.main.async {
                self.showAlert(with: alert)
            }
        }
    }

    func showAlert(with message: String) {
        alertMessage = message
        isAlerting = true
        WKInterfaceDevice.current().play(.notification)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.resetAlert()
        }
    }

    func resetAlert() {
        alertMessage = "인식중"
        isAlerting = false
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession 활성화 오류: \(error.localizedDescription)")
        } else {
            print("WCSession 활성화 성공: 상태 \(activationState.rawValue)")
        }
    }
}
