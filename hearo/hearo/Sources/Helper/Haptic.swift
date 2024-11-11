//
//  Haptic.swift
//  hearo
//
//  Created by Pil_Gaaang on 11/6/24.
//

import Foundation
import UIKit

// MARK: - Haptic 피드백 트리거
func triggerHapticFeedback(for offset: CGFloat, targetOffset: CGFloat) {
    let intensity = min(max(offset / targetOffset, 0), 1.0) // 진동 강도 (0~1)
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred(intensity: CGFloat(intensity)) // 강도 기반 진동
}

func triggerFinalHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success) // 강한 성공 진동
}

// MARK: - Predefined Haptic Feedback
func triggerSuccessHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

func triggerWarningHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.warning)
}

func triggerErrorHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.error)
}
