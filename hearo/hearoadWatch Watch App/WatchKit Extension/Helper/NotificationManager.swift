//
//  NotificationManager.swift
//  hearo
//
//  Created by 규북 on 10/18/24.
//

import UserNotifications

class NotificationManager {
  static let shared = NotificationManager()
  
  // 알림 권한 요청 함수
  func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if granted {
        print("알림 권한 허용됨")
      } else {
        print("알림 권한 거부됨")
      }
    }
  }
}
