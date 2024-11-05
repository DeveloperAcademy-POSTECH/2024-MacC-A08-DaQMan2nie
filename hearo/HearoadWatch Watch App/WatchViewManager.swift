////
////  WatchViewManager.swift
////  HearoadWatch Watch App
////
////  Created by Pil_Gaaang on 10/31/24.
////
//
//import WatchKit
//import SwiftUI
//import WatchConnectivity
//
//class WatchViewManager: NSObject, WCSessionDelegate, ObservableObject {
//    @Published var currentView: String = "home" // 초기화 값
//    @Published var alertMessage: String = ""    // 알림 메시지 속성 추가
//
//    override init() {
//        super.init()
//        
//        if WCSession.isSupported() {
//            WCSession.default.delegate = self
//            WCSession.default.activate()
//        }
//    }
//
//    // 수신한 Application Context 데이터 처리
//    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
//        DispatchQueue.main.async {
//            if let view = applicationContext["currentView"] as? String {
//                print("Watch에서 수신한 Application Context 데이터: \(view)")
//                self.currentView = view
//            } else {
//                print("Watch에서 수신한 Application Context에 'currentView' 키가 없습니다.")
//            }
//        }
//    }
//
//    // 수신한 Message 데이터 처리
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        DispatchQueue.main.async {
//            if let view = message["currentView"] as? String {
//                print("Watch에서 수신한 Message 데이터: \(view)")
//                self.currentView = view
//            } else {
//                print("Watch에서 수신한 Message에 'currentView' 키가 없습니다.")
//            }
//        }
//    }
//    
//    // 알림 메시지를 화면에 표시하고 진동을 발생시키는 메서드
//    private func triggerAlert(with alertMessage: String) {
//        WKInterfaceDevice.current().play(.notification) // 진동 발생
//        showAlert(alertMessage: alertMessage)           // 화면에 경고 표시
//    }
//    
//    // 알림 팝업을 표시하는 메서드
//    private func showAlert(alertMessage: String) {
//        let action = WKAlertAction(title: "확인", style: .default) { }
//        
//        // 현재 활성화된 인터페이스 컨트롤러에서 경고를 표시
//        if let controller = WKExtension.shared().visibleInterfaceController {
//            controller.presentAlert(withTitle: "경고", message: alertMessage, preferredStyle: .alert, actions: [action])
//        } else {
//            print("활성 인터페이스 컨트롤러를 찾을 수 없습니다.")
//        }
//    }
//    
//    // WCSessionDelegate 필수 메서드
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        if let error = error {
//            print("WCSession 활성화 오류: \(error.localizedDescription)")
//        } else {
//            print("WCSession 활성화 완료. 상태: \(activationState.rawValue)")
//        }
//    }
//}
