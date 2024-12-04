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
  static let shared = WatchSessionManager() // 싱글톤 인스턴스 생성
  
  @Published var alertMessage: String = " " // 기본 메시지
  @Published var isAlerting: Bool = false // 알림 상태 확인
  @Published var isIOSConnected: Bool = false // iOS 연결 상태
  @Published var currentScreen: String = "home" // 기본값 home
  
  private override init() {
    super.init()
    
    if WCSession.isSupported() {
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }
  
  // MARK: - iOS에서 데이터 수신
  // iOS에서 경고 메시지를 수신하는 메서드
  func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
    if let root = message["currentRoot"] as? String {
      DispatchQueue.main.async {
        self.currentScreen = root
        print("애플워치 - 아이폰 현재 화면 메시지 수신: \(root)")
      }
    } else if let alert = message["alert"] as? String {
      DispatchQueue.main.async {
        self.showAlert(with: alert) // 메시지 수신 후 즉각적으로 알림 표시
        print("애플워치 - 메시지 수신: \(alert)")
      }
    }
  }
  
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    if let root = applicationContext["currentRoot"] as? String {
      DispatchQueue.main.async {
        self.currentScreen = root
        print("워치 앱 - ApplicationContext 아이폰 현재 화면 데이터 수신: \(root)")
      }
    } else if let alert = applicationContext["alert"] as? String {
      DispatchQueue.main.async {
        self.showAlert(with: alert)
        print("워치 앱 - ApplicationContext 데이터 수신: \(alert)")
      }
    }
    
    if let highestConfidenceSound = applicationContext["highestConfidenceSound"] as? String {
      DispatchQueue.main.async {
        self.showAlert(with: highestConfidenceSound) // 수신한 소리를 알림으로 표시
        print("애플워치 - applicationContext 데이터 수신: \(highestConfidenceSound)")
      }
    }
  }
  
  // iOS 연결 상태 변경 시 호출
  func sessionReachabilityDidChange(_ session: WCSession) {
    DispatchQueue.main.async {
      self.isIOSConnected = session.isReachable
      print("iOS 연결 상태 변경됨: \(session.isReachable ? "연결됨" : "연결되지 않음")")
      
      // iOS로 연결 상태 변경 메시지 전송
      self.sendMessageToIOS(key: "connectionStatus", value: session.isReachable ? "connected" : "disconnected")
    }
  }
  
  
  // MARK: - iOS로 데이터 전송
  func sendMessageToIOS(key: String, value: String) {
    guard WCSession.default.activationState == .activated else {
      print("WCSession이 활성화되지 않아 데이터 전송 실패")
      return
    }
    
    if WCSession.default.isReachable {
      let message = [key: value]
      WCSession.default.sendMessage(message, replyHandler: nil) { error in
        print("워치 앱에서 iOS로 메시지 전송 실패: \(error.localizedDescription)")
      }
    } else {
      print("iOS 앱이 연결되지 않아 데이터 전송 실패")
    }
  }
  
  func updateApplicationContext(key: String, value: String) {
    do {
      try WCSession.default.updateApplicationContext([key: value])
      print("워치 앱에서 iOS로 ApplicationContext 전송 성공")
    } catch {
      print("워치 앱에서 ApplicationContext 전송 실패: \(error.localizedDescription)")
    }
  }
  
  
  // MARK: - 알림 표시 메서드
  // 이미지 이름을 반환하는 메서드
  func alertImageName() -> String {
    switch alertMessage {
    case "Carhorn":
      return "Car" // carhorn 이미지 이름
    case "Siren":
      return "Siren" // siren 이미지 이름
    case "Bicyclebell":
      return "Bicycle" // bicycle 이미지 이름
    default:
      return "Car" // 기본 알림 아이콘
    }
  }
  
  func alertTextName() -> String {
    switch alertMessage {
    case "Carhorn":
      return "자동차" // carhorn 텍스트 이름
    case "Siren":
      return "사이렌" // siren 덱스트 이름
    case "Bicyclebell":
      return "자전거" // bicycle 덱스트 이름
    default:
      return "자동차" // 기본 알림 아이콘
    }
  }
  
  // 3초 동안 알림 표시 후 기본 상태로 복구
  func showAlert(with message: String) {
    // "녹음 시작 전" 메시지는 무시
    guard message != "녹음 시작 전" else {
      print("메시지 무시: \(message)")
      return
    }
    
    alertMessage = message
    isAlerting = true
    
    // 강한 진동 알림 발생
    playUrgentHapticPattern()
    
    // UI 업데이트: 빨간 배경, 아이콘 표시
    DispatchQueue.main.async {
      print("UI 업데이트 - 배경색: 빨간색, 메시지: \(message)")
    }
    
    // 3초 후에 기본 상태로 복구
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.resetAlert()
    }
  }
  
  // 긴급 상황을 위한 강한 진동 패턴
  func playUrgentHapticPattern() {
    // 반복 횟수 및 간격 설정
    let repeatCount = 30 // 진동 반복 횟수
    let interval: TimeInterval = 0.05 // 반복 간격 (0.1초)
    
    // 반복적으로 강한 진동을 재생하는 패턴
    for i in 0..<repeatCount {
      DispatchQueue.main.asyncAfter(deadline: .now() + (interval * Double(i))) {
        WKInterfaceDevice.current().play(.failure) // 강한 피드백을 주는 진동
      }
    }
  }
  
  // 기본 상태로 복구하는 메서드
  func resetAlert() {
    alertMessage = "인식중"
    isAlerting = false
    print("UI 상태 복구 - 배경색: 검정, 메시지: 기본 상태")
  }
  
  // MARK: - WCSessionDelegate 메서드
  // WCSession 활성화 완료 시 호출되는 메서드
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if activationState == .activated {
      print("워치 앱에서 WCSession으로 활성화 성공")
    }
    if let error = error {
      print("워치 앱에서 WCSession 활성화 실패: \(error.localizedDescription)")
    }
  }
  
}
