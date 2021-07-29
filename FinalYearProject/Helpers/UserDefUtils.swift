//
//  UserDefUtils.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 17/07/2021.
//

import UIKit

class UserDefUtils {
    
    static private let purchasedPowerKey = "purchasedPower"
    static private let userConsumedTodayPowerKey = "todayPower"
    static private let thresholdPowerKey = "thresholdPower"
    static private let usersOverallPowerConsumptionKey = "overallPower"
    static private let usersIsAutomaticRefresh = "isAutomaticRefresh"
    static private let userDailyNotificationTime = "timeDailyNotification"
    static private let dailyNotificationIdentifier  = "dailyNotificaton"
    static private let chartTintColorKey = "chartColor"



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
            UserDefaults.standard.set(newValue, forKey: userDailyNotificationTime)
            UserDefaults.standard.synchronize()
//            hmmcenter.removeAllPendingNotificationRequests()
            hmmcenter.add(updateDailyNotification()){
                (error) in
                print(error?.localizedDescription ?? "")
            }
//            UIApplication.shared.applicationIconBadgeNumber += 1
        }
    }
    
    static var userTodayConsumptionPower:Double{
        get{
            return  UserDefaults.standard.double(forKey: userConsumedTodayPowerKey)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: userConsumedTodayPowerKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var userChartTintColor:UIColor{
        get{
            var colorReturnded: UIColor?
            if let colorData = UserDefaults.standard.data(forKey: chartTintColorKey) {
              do {
                if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                  colorReturnded = color
                }
              } catch {
                print("Error UserDefaults")
              }
            }
            return colorReturnded ?? .turquoise
        }set{
            var colorData: NSData?
            do {
              let data = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false) as NSData?
              colorData = data
            } catch {
              print("Error UserDefaults")
            }
            UserDefaults.standard.set(colorData, forKey: chartTintColorKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    fileprivate static func updateDailyNotification() -> UNNotificationRequest{
        let content = UNMutableNotificationContent()
        content.title = "Today's Power Consumption 💡"
        content.body = "Ibukunoluwa, you have used up \(String(format: "%.4f", UserDefUtils.userTodayConsumptionPower)) kwH today"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .defaultCritical
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = dailyNotificationTime.component(.hour)
        print(dailyNotificationTime.component(.hour))
        dateComponents.minute = dailyNotificationTime.component(.minute)
        print(dailyNotificationTime.component(.minute))
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: dailyNotificationIdentifier, content: content, trigger: trigger)
        
        return request
    }
    
}

extension UserDefaults {
  func colorForKey(key: String) -> UIColor? {
    var colorReturnded: UIColor?
    if let colorData = data(forKey: key) {
      do {
        if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
          colorReturnded = color
        }
      } catch {
        print("Error UserDefaults")
      }
    }
    return colorReturnded
  }
  
  func setColor(color: UIColor?, forKey key: String) {
    var colorData: NSData?
    if let color = color {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
        colorData = data
      } catch {
        print("Error UserDefaults")
      }
    }
    set(colorData, forKey: key)
  }
}
