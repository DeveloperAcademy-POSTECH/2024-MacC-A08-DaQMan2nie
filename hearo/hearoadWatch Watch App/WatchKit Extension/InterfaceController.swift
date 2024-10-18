//
//  InterfaceController.swift
//  hearo
//
//  Created by 규북 on 10/18/24.
//

import WatchKit
import UserNotifications
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    // WatchConnectivity 세션 활성화
    if WCSession.default.activationState == .notActivated {
      WCSession.default.delegate = self
      WCSession.default.activate()
    }
  }
  
  // iPhone에서 소리 감지 메시지 수진
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    if let soundType = message["soundDetected"] as? String {
      switch soundType {
      case "BicycleHorn":
        sendNotification(title: "경고!", body: "자전거 경적 소리 감지!")
      case "CarHorn":
        sendNotification(title: "경고!", body: "자동차 경적 소리 감지!")
      case "Siren":
        sendNotification(title: "경고!", body: "사이렌 소리 감지!")
      default:
        break
      }
    }
  }
  
  // 워치에서 Notification 생성
  func sendNotification(title: String, body: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
    
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("알림 등록 실패: \(error.localizedDescription)")
      } else {
        print("알림 성공적으로 전송됨")
      }
    }
  }
  
  // WCSessionDelegate 필수 메서드들
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    print("WCSession 활성화 완료")
  }
}
