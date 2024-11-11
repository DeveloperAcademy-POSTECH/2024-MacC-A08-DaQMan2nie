//
//  Haptic.swift
//  hearo
//
//  Created by Pil_Gaaang on 11/6/24.
//

import Foundation
import UIKit

// MARK: - Haptic Manager

class HapticManager {
    static let shared = HapticManager()
    
    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private var lastHapticTime: Date = Date() // 마지막 햅틱 실행 시간

    private init() {
        prepareHaptics()
    }
    
    private func prepareHaptics() {
        impactGenerator.prepare()
        notificationGenerator.prepare()
    }

    func triggerImpact(intensity: CGFloat) {
        guard Date().timeIntervalSince(lastHapticTime) > 0.1 else { return } // 최소 0.1초 간격
        lastHapticTime = Date()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.impactGenerator.prepare() // 미리 준비
            DispatchQueue.main.async {
                self.impactGenerator.impactOccurred(intensity: intensity)
            }
        }
    }

    func triggerNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.notificationGenerator.prepare()
            DispatchQueue.main.async {
                self.notificationGenerator.notificationOccurred(type)
            }
        }
    }
}
// MARK: - Haptic 피드백 트리거
private var isFinalHapticTriggered = false

func triggerHapticFeedback(for offset: CGFloat, targetOffset: CGFloat) {
    let intensity = min(max(offset / targetOffset, 0), 1.0)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        HapticManager.shared.triggerImpact(intensity: intensity)
    }
}

func triggerFinalHaptic() {
    guard !isFinalHapticTriggered else { return }
    isFinalHapticTriggered = true
    
    DispatchQueue.main.async {
        HapticManager.shared.triggerNotification(type: .success)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        isFinalHapticTriggered = false
    }
}

func triggerSuccessHaptic() {
    HapticManager.shared.triggerNotification(type: .success)
}

func triggerWarningHaptic() {
    HapticManager.shared.triggerNotification(type: .warning)
}

func triggerErrorHaptic() {
    HapticManager.shared.triggerNotification(type: .error)
}
