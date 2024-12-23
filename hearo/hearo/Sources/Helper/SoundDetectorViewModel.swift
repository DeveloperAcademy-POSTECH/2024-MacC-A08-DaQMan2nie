//
//  SoundDetectorViewModel.swift
//  hearo
//
//  Created by 규북 on 10/13/24.
//
import Foundation
import Combine
import WatchConnectivity

class SoundDetectorViewModel: NSObject, ObservableObject, WCSessionDelegate {
  @Published var isRecording = false
  @Published var classificationResult: String = "녹음 시작 전"
  @Published var confidence: Double = 0.0
  @Published var isWatchConnected: Bool = false // 애플워치 연결 상태를 추적
  
  
  private var hornSoundDetector: HornSoundDetector
  private var appRootManager: AppRootManager
  private var cancellables = Set<AnyCancellable>()
  private var connectionCheckTimer: Timer?
  
  init(appRootManager: AppRootManager) {
    self.appRootManager = appRootManager
    self.hornSoundDetector = HornSoundDetector(appRootManager: appRootManager)
    super.init()
    setupBindings()
    setupWCSession() // WCSession 설정
    startConnectionCheckTimerIfNeeded()
    
    // NotificationCenter를 통해 detectedSoundNotification 노티피케이션 수신 등록
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleDetectedSoundNotification(_:)),
      name: .detectedSoundNotification,
      object: nil
    )
  }
  
  
  @objc private func handleDetectedSoundNotification(_ notification: Notification) {
    if let sound = notification.userInfo?["sound"] as? String {
      print("SoundDetectorViewModel에서 전달받은 sound: \(sound)")
      sendWarningToWatch(alert: sound) // 애플워치로 알림 전송
    }
  }
  
  deinit {
    connectionCheckTimer?.invalidate()
    NotificationCenter.default.removeObserver(self, name: .detectedSoundNotification, object: nil)
  }
  
  private func setupBindings() {
    hornSoundDetector.$isRecording
      .assign(to: \.isRecording, on: self)
      .store(in: &cancellables)
    
    // HornSoundDetector에서 Warning 발생 시 직접 Watch로 전달
    hornSoundDetector.$classificationResult
      .sink { [weak self] result in
        guard let self = self else { return }
        print("SoundDetectorViewModel에서 전달받은 classificationResult: \(result)")
        self.sendWarningToWatch(alert: result) // Watch에 전달
      }
      .store(in: &cancellables)
    
    hornSoundDetector.$confidence
      .assign(to: \.confidence, on: self)
      .store(in: &cancellables)
  }
  
  func setupWCSession() {
    if WCSession.isSupported() {
      let session = WCSession.default
      session.delegate = self
      session.activate()
      print("WCSession 활성화 요청")
      updateWatchConnectionState() // 초기 연결 상태 확인
    }
    else {
      print("WCSession이 지원되지 않습니다.")
    }
  }
  
  private func startConnectionCheckTimerIfNeeded() {
    // 현재 화면이 WorkingView가 아니라면 타이머 중지
    guard appRootManager.currentRoot == .working else {
      stopConnectionCheckTimer()
      return
    }
    
    // 타이머를 중복해서 실행하지 않도록 기존 타이머를 중지
    connectionCheckTimer?.invalidate()
    connectionCheckTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
//      guard let self else { return }
      self?.updateWatchConnectionState()
    }
    print("워치 연결 확인 타이머 시작(현재 화면: \(appRootManager.currentRoot))")
  }
  
  private func stopConnectionCheckTimer() {
    connectionCheckTimer?.invalidate()
    connectionCheckTimer = nil
    print("타이머 중지 (현채 화면: \(appRootManager.currentRoot))")
  }
  
  private func updateWatchConnectionState() {
    // 애플워치 연결 상태를 업데이트
    isWatchConnected = WCSession.default.isReachable
    print("애플워치 연결 상태 업데이트: \(isWatchConnected ? "연결됨" : "연결되지 않음")")
  }
  
  
  func startRecording() {
    hornSoundDetector.startRecording()
  }
  
  func stopRecording() {
    hornSoundDetector.stopRecording()
  }
  
  private func sendWarningToWatch(alert: String) {
    guard WCSession.default.activationState == .activated else {
      print("WCSession이 활성화되지 않아 전송 보류: \(alert)")
      return
    }
    
    if WCSession.default.isReachable {
      let message = ["alert": alert]
      WCSession.default.sendMessage(message, replyHandler: nil) { error in
        print("애플워치로 메시지 전송 실패: \(error.localizedDescription)")
      }
    } else {
      do {
        try WCSession.default.updateApplicationContext(["alert": alert])
        print("애플워치에 ApplicationContext로 데이터 전달 성공: \(alert)")
      } catch {
        print("애플워치 ApplicationContext 데이터 전달 실패: \(error.localizedDescription)")
      }
    }
  }
  
  
  
  func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
    if let connectionStatus = message["connectionStatus"] as? String {
      //          print("iOS 앱에서 워치 연결 상태 메시지 수신: \(connectionStatus)")
      
      // 워치에서 상태 변경 메시지를 받았으므로 상태 업데이트
      DispatchQueue.main.async {
        self.updateWatchConnectionState()
      }
    }
  }
  
  
  // WCSessionDelegate 메서드
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    DispatchQueue.main.async {
      self.updateWatchConnectionState()
    }
    
    switch activationState {
    case .notActivated:
      print("WCSession이 활성화되지 않음.")
    case .inactive:
      print("WCSession이 비활성 상태.")
    case .activated:
      print("WCSession 활성화 성공.")
    @unknown default:
      print("알 수 없는 WCSession 상태.")
    }
    
    if let error = error {
      print("WCSession 활성화 실패: \(error.localizedDescription)")
    }
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) {
    // 세션이 비활성화되었을 때 로그를 남기거나 필요한 작업을 수행
    print("WCSession이 비활성화되었습니다. 세션 상태: \(session.activationState.rawValue)")
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
    // 세션이 비활성화된 후 다시 활성화를 준비
    print("WCSession이 비활성화되었습니다. 새로운 세션을 활성화합니다.")
    WCSession.default.activate()
  }
  
}
