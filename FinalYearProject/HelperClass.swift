//
//  HelperClass.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 11/06/2021.
//

import Foundation
import RealmSwift

struct AdaFruitResult {
    var current:Double
    var date_stamp:String
    var id:Int
    var power:Double
    var time_stamp:String
    var voltage:Double
    var iOSDate:Date
    var iOSTime:Date
    
    func createPAdaObject() -> PersistentAdaFruit{
        let hmm:PersistentAdaFruit = .init(date_stamp: self.date_stamp, time_stamp: self.time_stamp, iOSDate: self.iOSDate, iOSTime: self.iOSTime)
        hmm.current = RealmOptional(self.current)
        hmm.id = RealmOptional(self.id)
        hmm.power = RealmOptional(self.power)
        hmm.voltage = RealmOptional(self.voltage)
        return hmm
    }
    
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
