//
//  UserDefUtils.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 17/07/2021.
//

import UIKit

class UserDefUtils {
    
    static private var purchasedPowerKey = "purchasedPower"
    static private var userConsumedTodayPower = "todayPower"
    static private var thresholdPowerKey = "thresholdPower"
    static private var usersOverallPowerConsumptionKey = "overallPower"
    static private var usersIsAutomaticRefresh = "isAutomaticRefresh"
    static private var userDailyNotificationTime = "timeDailyNotification"
    static let dailyNotificationIdentifier  = "dailyNotificaton"


    static let hmmcenter = UNUserNotificationCenter.current()
    
    static var userPurchasedPower:Double{
        get{
            return  UserDefaults.standard.double(forKey: purchasedPowerKey)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: purchasedPowerKey)
            UserDefaults.standard.synchronize()
            
        }
    }
    
    static var userThresholdPower:Double{
        get{
            return  UserDefaults.standard.double(forKey: thresholdPowerKey)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: thresholdPowerKey)
            UserDefaults.standard.synchronize()
            
        }
    }

    static var userOverallConsumptionPower:Double{
        get{
            return  UserDefaults.standard.double(forKey: usersOverallPowerConsumptionKey)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: usersOverallPowerConsumptionKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isAutomaticRefresh: Bool{
        get{
            return UserDefaults.standard.bool(forKey: usersIsAutomaticRefresh)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: usersIsAutomaticRefresh)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var dailyNotificationTime: Date{
        get{
            return UserDefaults.standard.object(forKey: userDailyNotificationTime) as? Date ?? Date()
        }
        set{
            hmmcenter.add(updateDailyNotification())
            UIApplication.shared.applicationIconBadgeNumber += 1
            UserDefaults.standard.set(newValue, forKey: userDailyNotificationTime)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var userTodayConsumptionPower:Double{
        get{
            return  UserDefaults.standard.double(forKey: userConsumedTodayPower)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: userConsumedTodayPower)
            UserDefaults.standard.synchronize()
        }
    }
    
    fileprivate static func updateDailyNotification() -> UNNotificationRequest{
        let content = UNMutableNotificationContent()
        content.title = "Today's Power Consumption 💡"
        content.body = "Ibukunoluwa, you have used up \(String(format: "%.2f", UserDefUtils.userConsumedTodayPower)) kwH today"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .defaultCritical
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = dailyNotificationTime.component(.hour)
        dateComponents.minute = dailyNotificationTime.component(.minute)
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: dailyNotificationIdentifier, content: content, trigger: trigger)
        
        return request
    }
    
}
