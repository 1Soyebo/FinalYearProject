//
//  UserDefUtils.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 17/07/2021.
//

import Foundation

class UserDefUtils {
    
    static private var purchasedPowerKey = "purchasedPower"
    static private var thresholdPowerKey = "thresholdPower"
    static private var usersOverallPowerConsumptionKey = "overallPower"
    static private var usersIsAutomaticRefresh = "isAutomaticRefresh"
    static private var userDailyNotificationTime = "timeDailyNotification"

    
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
        }
    }
    
}
