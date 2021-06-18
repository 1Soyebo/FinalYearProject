//
//  HelperClass.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 11/06/2021.
//

import Foundation

struct AdaFruitResult {
    var current:Double
    var date_stamp:String
    var id:Int
    var power:Double
    var time_stamp:String
    var voltage:Double
    var iOSDate:Date
    var iOSTime:Date
    
}


class UserDefUtils {
    
    static private var purchasedPowerKey = "purchasedPower"
    static private var thresholdPowerKey = "thresholdPower"
    static private var usersPowerConsumptionKey = "overallPower"
    
    
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

    static var userConsumptionPower:Double{
        get{
            return  UserDefaults.standard.double(forKey: usersPowerConsumptionKey)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: usersPowerConsumptionKey)
            UserDefaults.standard.synchronize()
            
        }
    }
    
}
