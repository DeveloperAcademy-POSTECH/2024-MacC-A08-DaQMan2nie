//
//  Haptic.swift
//  hearo
//
//  Created by Pil_Gaaang on 11/6/24.
//

import Foundation
import UIKit

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
