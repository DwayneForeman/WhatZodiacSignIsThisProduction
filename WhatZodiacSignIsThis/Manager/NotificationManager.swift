//
//  NotificationManager.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 10/28/23.
//

import UIKit
import UserNotifications

class NotificationManager: UIViewController {

    static let shared = NotificationManager()
    
    func getNotificationAuthorizationFromuser() {
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        // Request authorization for notifications
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (didAllow, error) in
            if didAllow {
                // Schedule the notifications
                self.scheduleMorningNotification()
                self.scheduleEveningNotification()
            }
        }
        
    }
    
    func scheduleMorningNotification() {
        let content = UNMutableNotificationContent()
        content.title = "What Sign Is This?"
        content.body = UpgradedJokes.shared.upgradedJokesArray.randomElement()?.value.randomElement() ?? "Get your daily dose of jokes!"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 11 // 11 AM
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let uuidString = "MorningNotification" // Use a consistent identifier for this notification
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request)
    }

    func scheduleEveningNotification() {
        let content = UNMutableNotificationContent()
        content.title = "What Sign Is This?"
        content.body = UpgradedJokes.shared.upgradedJokesArray.randomElement()?.value.randomElement() ?? "Get your daily dose of jokes!"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20 // 8 PM
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let uuidString = "EveningNotification" // Use a consistent identifier for this notification
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request)
    }
  
}
