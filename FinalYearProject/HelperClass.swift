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
    
    
    static var userPurchasedPower:Double{
        get{
            if let savedData = UserDefaults.standard.value(forKey: purchasedPowerKey) as? Data{
                do{
                    return try PropertyListDecoder().decode(Double.self, from: savedData)
                }catch{
                    print(error)
                    return 50
                }
            }
            return 50
        }
        set{
            do {
                UserDefaults.standard.set(try PropertyListEncoder().encode(newValue), forKey: purchasedPowerKey)
                UserDefaults.standard.synchronize()
            }catch{
                print(error)
            }
        }
    }
    
    static var userThresholdPower:Double{
        get{
            if let savedData = UserDefaults.standard.value(forKey: thresholdPowerKey) as? Data{
                do{
                    return try PropertyListDecoder().decode(Double.self, from: savedData)
                }catch{
                    print(error)
                    return 0
                }
            }
            return 0
        }
        set{
            do {
                UserDefaults.standard.set(try PropertyListEncoder().encode(newValue), forKey: thresholdPowerKey)
                UserDefaults.standard.synchronize()
            }catch{
                print(error)
            }
        }
    }

    
    
}
