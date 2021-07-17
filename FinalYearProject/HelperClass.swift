//
//  HelperClass.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 11/06/2021.
//

import Foundation
import RealmSwift
import Charts

extension Date{
    func toShortString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: self)
    }
}


extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}



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



public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    private let objects:[AdaFruitResult]
    
    init(objects: [AdaFruitResult]) {
        self.objects = objects
        super.init()
        dateFormatter.dateFormat = "HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value >= 0 && value < Double(objects.count){
            let object = objects[Int(value)]
            return dateFormatter.string(from: object.iOSTime)
        }
        return ""
    }
}


//    func readFromRealm(){
//        array_realm_persistentAdaFruit = localRealm.objects(ArraysPersistentAdaFruit.self)
////        print(array_realm_persistentAdaFruit?.count)
//        if let unwrapped_Array_realm_persistentAdaFruit = array_realm_persistentAdaFruit{
//            if unwrapped_Array_realm_persistentAdaFruit.count > 0{
//                var ha = [AdaFruitResult]()
//                var num = 0
////                for index_num in 0..<unwrapped_Array_realm_persistentAdaFruit.count-1{
//                    for why in unwrapped_Array_realm_persistentAdaFruit[0].listOfPersAdafruits{
//                        num += 1
//                        ha.append(AdaFruitResult.init(current: why.current.value ?? 0, date_stamp: why.date_stamp ?? "", id: why.id.value  ?? 0, power: why.power.value  ?? 0, time_stamp: why.time_stamp  ?? "", voltage: why.voltage.value  ?? 0, iOSDate: why.iOSDate ?? Date(), iOSTime: why.iOSTime ?? Date()))
//                    }
////                    if num == 1{
////                        break;
////                    }
//
////                }
//
//                print(num)
//                convertToChartDataEntry(array_adafruit: ha)
//            }
//        }
//        getChartData()
//
//
//    }


fileprivate func checkIfLastDataFromAPICallIsTheSameAsRealm(){
    
//        if let array_realm_persistentAdaFruit = array_realm_persistentAdaFruit{
//            let hmm = Array(array_realm_persistentAdaFruit)
//            let hmmflatmap = hmm.flatMap({
//                k in k.listOfPersAdafruits
//            })
//            print(hmmflatmap)
//            print(1)
//        localRealm.deleteAll()
        
        
//            if let last_array_realm_persistentAdaFruit = array_realm_persistentAdaFruit.last{
//                if let last_last_array_realm_persistentAdaFruit = last_array_realm_persistentAdaFruit.listOfPersAdafruits.last{
//                    if let last_last_array_realm_persistentAdaFruit_id = last_last_array_realm_persistentAdaFruit.id.value{
//                        if let nonpersistentLast = array_power_results.last{
//
//                            if last_last_array_realm_persistentAdaFruit_id == nonpersistentLast.id{
//                                return
//                            }else{
//
//                                let oneArray = array_power_results.filter({
//                                    $0.iOSDate == nonpersistentLast.iOSDate
//                                })
//
//
//                            }
//                        }
//                    }
//                }
//            }
//        }
    
}


//fileprivate func configureChartView(){
//    myLineChart.rightAxis.enabled = false
//    myLineChart.xAxis.labelTextColor = .gray
//    myLineChart.noDataText = "Downloading Chart Data..."
//    myLineChart.chartDescription?.text = "Time"
//
//    let firstLegend = LegendEntry.init(label: "Power in Kwh", form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor.black)
//    myLineChart.legend.setCustom(entries: [firstLegend])
////        myLineChart.xAxis.valueFormatter =
//    
//}
