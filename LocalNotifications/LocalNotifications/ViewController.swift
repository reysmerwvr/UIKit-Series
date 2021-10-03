//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Reysmer Valle on 10/3/21.
//
import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocalDefault))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        })
    }
    
    @objc func scheduleLocalDefault() {
        self.scheduleLocal(withDateInterval: false, forNextHours: 0.0, withTimeInterval: 3.0, withRepeats: false)
    }
    
    @objc func scheduleLocal(withDateInterval isDateInterval: Bool = false, forNextHours hours: Double = 0.0, withTimeInterval timeInterval: Double = 5.0, withRepeats repeats: Bool = false) -> Void {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        let content  = createNotificationContent(withTitle: "Late wake up call", withBody: "The early bird catches the worm, but the second mouse get the cheese", withCategoryIdentifier: "alarm", withUserInfo: ["customData": "fizzbuzz"], withSound: .default)
        var trigger: UNNotificationTrigger
        if (!isDateInterval) {
            trigger = createIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        } else {
            let date = Date().addingTimeInterval(hours * 3600.0)
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day,
                                                          .hour, .minute, .second,], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        }
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
            case "show":
                print("Show more information")
            case "remind":
                print("Remind later")
                scheduleLocal(withDateInterval: true, forNextHours: 0.010) // 30 seconds
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    func createNotificationContent(withTitle title: String, withBody body: String, withCategoryIdentifier categoryIdentifier: String, withUserInfo userInfo: Dictionary<String, String>, withSound sound: UNNotificationSound) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = categoryIdentifier
        content.userInfo = userInfo
        content.sound = sound
        return content
    }
    
    func createCalentarNotificationTrigger(dateMatching: DateComponents, repeats: Bool = false) -> UNNotificationTrigger {
        return UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: repeats)
    }
    
    func createIntervalNotificationTrigger(timeInterval: Double, repeats: Bool = false) -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
    }
    
}

