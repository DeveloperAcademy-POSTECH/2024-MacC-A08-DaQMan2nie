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
    @Published var isWatchConnected: Bool = false // 애플 워치 연결 상태 추적

    private var hornSoundDetector: HornSoundDetector
    private var appRootManager: AppRootManager
    private var cancellables = Set<AnyCancellable>()
    
    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.hornSoundDetector = HornSoundDetector(appRootManager: appRootManager)
        super.init()
        setupBindings()
        setupWCSession() // WCSession 설정
        updateWatchConnectionStatus() // 초기 연결 상태 확인


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
    
    private func setupWCSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    private func updateWatchConnectionStatus() {
           let session = WCSession.default
           DispatchQueue.main.async {
               self.isWatchConnected = session.isReachable // 애플 워치 연결 여부 업데이트
               print("애플 워치 연결 상태: \(self.isWatchConnected ? "연결됨" : "연결 안 됨")")
           }
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
    
    // WCSessionDelegate 메서드
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .notActivated:
            print("WCSession이 활성화되지 않음.")
        case .inactive:
            print("WCSession이 비활성 상태.")
        case .activated:
            updateWatchConnectionStatus() // 연결 상태 업데이트
            print("WCSession 활성화 성공.")
        @unknown default:
            print("알 수 없는 WCSession 상태.")
        }

        if let error = error {
            print("WCSession 활성화 실패: \(error.localizedDescription)")
        }
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession이 비활성화되었습니다.")
        updateWatchConnectionStatus() // 연결 상태 업데이트
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession이 비활성화되었습니다. 새로운 세션을 활성화합니다.")
        WCSession.default.activate()
        updateWatchConnectionStatus() // 연결 상태 업데이트
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        updateWatchConnectionStatus() // 연결 상태 업데이트
        print("WCSession 연결 상태 변경됨: \(session.isReachable ? "연결됨" : "연결 안 됨")")
    }
    
}
