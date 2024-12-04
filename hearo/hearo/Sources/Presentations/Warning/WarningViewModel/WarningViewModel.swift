//
//  WarningViewModel.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/17/24.
//
import Foundation

class WarningViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
    }

    func alertImageName() -> String {
        let detectedSound = appRootManager.detectedSound ?? "nil" // 기본값 설정
        print("⚠️ WarningViewModel에서 감지된 소리: \(detectedSound)")
        switch detectedSound {
        case "Carhorn":
            return "Car" // 자동차 이미지 이름
        case "Siren":
            return "Siren" // 사이렌 이미지 이름
        case "Bicyclebell":
            return "Bicycle" // 자전거 이미지 이름
        default:
            return "exclamationmark.triangle.fill" // 기본 경고 아이콘
        }
    }
    func alertName() -> String {
        let detectedSoundname = appRootManager.detectedSound ?? "nil" // 기본값 설정
        
        switch detectedSoundname {
        case "Car-text":
            return "Bicycle-text"
        case "Siren-text":
            return "사이렌"
        case "Bicyclebell":
            return "Bicycle-text"
        default:
            return "알 수 없음" // 디폴트값 설정
        }
    }


}
