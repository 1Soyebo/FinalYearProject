////
////  RealmPersistence.swift
////  FinalYearProject
////
////  Created by Ibukunoluwa Soyebo on 21/06/2021.
////
//
//import Foundation
//
//class PersistentAdaFruit:Object {
//    
//    convenience init(date_stamp: String? = nil, time_stamp: String? = nil, iOSDate: Date? = nil, iOSTime: Date? = nil) {
//        self.init()
//        self.date_stamp = date_stamp
//        self.time_stamp = time_stamp
//        self.iOSDate = iOSDate
//        self.iOSTime = iOSTime
//    }
//    
//    var current = RealmOptional<Double>()
//    @objc dynamic var date_stamp:String? = nil
//    var id = RealmOptional<Int>()
//    var power = RealmOptional<Double>()
//    @objc dynamic var time_stamp:String? = nil
//    var voltage = RealmOptional<Double>()
//    @objc dynamic var iOSDate:Date? = nil
//    @objc dynamic var iOSTime:Date? = nil
//    
//    
//    
//}
//
//
//class ArraysPersistentAdaFruit:Object{
//    
//    convenience init(iOSDate: Date? = nil) {
//        self.init()
//        self.iOSDate = iOSDate
//    }
//    
//    @objc dynamic var iOSDate:Date? = nil
//    var consumpitonTotal = RealmOptional<Double>()
//    var listOfPersAdafruits = List<PersistentAdaFruit>()
//}
