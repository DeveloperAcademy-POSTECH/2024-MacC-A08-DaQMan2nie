////
////  WatchviewManager.swift
////  hearo
////
////  Created by Pil_Gaaang on 10/31/24.
////
//
//import Foundation
//import Combine
//import WatchConnectivity
//
//class ViewManager: NSObject, WCSessionDelegate, ObservableObject {
//    static let shared = ViewManager()
//
//    @Published var currentView: String = "home" // 초기값을 "home"으로 설정
//
//    override init() {
//        super.init()
//        if WCSession.isSupported() && WCSession.default.activationState != .activated {
//            WCSession.default.delegate = self
//            WCSession.default.activate()
//        }
//    }
//    func retrySendMessage(view: String) {
//        let maxRetries = 3
//        var currentRetry = 0
//
//        func attemptSend() {
//            if WCSession.default.isReachable {
//                sendViewChangeMessage(view: view)
//            } else if currentRetry < maxRetries {
//                currentRetry += 1
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    attemptSend()
//                }
//            } else {
//                print("최대 재시도 횟수 초과. Watch가 연결되지 않음.")
//            }
//        }
//
//        attemptSend()
//    }
//
//    // 페이지 전환 시 Watch에 메시지 전송
//    func sendViewChangeMessage(view: String) {
//        guard WCSession.default.isReachable else {
//            print("Watch가 연결되지 않음 - 메시지 전송 불가")
//            return
//        }
//
//        let message = ["currentView": view.isEmpty ? "home" : view]
//
//        do {
//            try WCSession.default.updateApplicationContext(message)
//            print("iPhone -> Watch: \(view) 뷰 전환 상태 Application Context 전송 완료")
//        } catch {
//            print("Application Context 업데이트 오류: \(error.localizedDescription)")
//        }
//    }
//    
//    // iPhone에서 페이지 전환에 따른 함수 호출
//    func switchToHomeView() {
//        print("iPhone에서 홈 뷰 전환 요청")
//        sendViewChangeMessage(view: "home")
//    }
//
//    func switchToWorkingView() {
//        print("iPhone에서 워킹 뷰 전환 요청")
//        sendViewChangeMessage(view: "working")
//    }
//
//    func switchToWarningView() {
//        print("iPhone에서 워닝 뷰 전환 요청")
//        sendViewChangeMessage(view: "warning")
//    }
//
//    func switchToFinishView() {
//        print("iPhone에서 피니시 뷰 전환 요청")
//        sendViewChangeMessage(view: "finish")
//    }
//    
//    // 필수 WCSessionDelegate 메서드 구현
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        print("ViewWCSession 활성화 완료. 상태: \(activationState)")
//    }
//
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        print("ViewWCSession 비활성화됨")
//    }
//
//    func sessionDidDeactivate(_ session: WCSession) {
//        print("ViewWCSession 비활성화됨. 다시 활성화")
//        WCSession.default.activate()
//    }
//}
