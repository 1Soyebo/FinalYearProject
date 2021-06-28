//
//  ViewController.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 04/06/2021.
//

import UIKit
import Charts
import Alamofire
import RealmSwift
import DateToolsSwift

//2021-06-10
//18:28:29.694614

class HomeViewController: UIViewController {
    
    let localRealm = try! Realm()
    
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var lblCurrentPower: UILabel!
    @IBOutlet weak var lblTodayConsumption: UILabel!
    
    var array_Dates = [Date]()
    var array_of_array_powerResults = [[AdaFruitResult]]()
    
    var array_realm_persistentAdaFruit: Results<ArraysPersistentAdaFruit>?
    
    @IBOutlet weak var myLineChart: LineChartView!
    var array_power_results = [AdaFruitResult]()
    var array_chart_data_entry = [ChartDataEntry]()
    
    var availablePower:Double = 0
    
    var todayPower:Double = 0{
        didSet{
            lblTodayConsumption.text = "\(todayPower) kwH"
        }
    }
    
    var currentPower:Double = 0
    
    var overallConsumption:Double = 0{
        didSet{
            let o_consum2dp = String(format:"%.2f", UserDefUtils.userPurchasedPower - overallConsumption)
            lblAvailable.text = "\(o_consum2dp) kwH"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        registerForNotifications()
        setLabels()
//        localRealm.deleteAll()
//        print(3)
        readFromRealm()
//        self.getChartData()
        configureChartView()
//        repeateGetREquest()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [self] in
            lblAvailable.text = "\(UserDefUtils.userPurchasedPower - overallConsumption) kwH"
        }
    }
    
    func readFromRealm(){
        array_realm_persistentAdaFruit = localRealm.objects(ArraysPersistentAdaFruit.self)
//        print(array_realm_persistentAdaFruit?.count)
        if let unwrapped_Array_realm_persistentAdaFruit = array_realm_persistentAdaFruit{
            if unwrapped_Array_realm_persistentAdaFruit.count > 0{
                var ha = [AdaFruitResult]()
                var num = 0
                for index_num in 0..<unwrapped_Array_realm_persistentAdaFruit.count-1{
                    for why in unwrapped_Array_realm_persistentAdaFruit[index_num].listOfPersAdafruits{
                        num += 1
                        ha.append(AdaFruitResult.init(current: why.current.value ?? 0, date_stamp: why.date_stamp ?? "", id: why.id.value  ?? 0, power: why.power.value  ?? 0, time_stamp: why.time_stamp  ?? "", voltage: why.voltage.value  ?? 0, iOSDate: why.iOSDate ?? Date(), iOSTime: why.iOSTime ?? Date()))
                    }
                    
                }
                
                print(num)
                convertToChartDataEntry(array_adafruit: ha)
            }
        }
        getChartData()


    }
    
    fileprivate func setLabels(){
        lblAvailable.text = "0 kwH"
        lblCurrentPower.text = "0 kwH"
        lblTodayConsumption.text = "0 kwH"
    }
    
    fileprivate func repeateGetREquest(){
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { timer in
            self.getChartData()
        }
    }
    
    fileprivate func configureChartView(){
        myLineChart.rightAxis.enabled = false
        myLineChart.xAxis.labelTextColor = .gray
        myLineChart.noDataText = "Downloading Chart Data..."
        myLineChart.chartDescription?.text = "Power in Kwh"
        
    }
    
    fileprivate func setData(){
        let set1 = LineChartDataSet(entries: array_chart_data_entry)
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.fillColor = .black
        set1.mode = .cubicBezier
        set1.fillAlpha = 0.2
        set1.fill = Fill(color: .gray)
        set1.drawFilledEnabled = false
        
        let data = LineChartData(dataSet: set1)
        
        data.setDrawValues(false)
        myLineChart.data = data
        lblCurrentPower.text = "\(array_power_results.last?.power ?? 0) kwH"
    }
    
    fileprivate func convertToChartDataEntry(array_adafruit: [AdaFruitResult]){
        var m = 0.0
        array_chart_data_entry = []
        if array_adafruit.count > 0{
            for single_adafruit in array_adafruit{
                m = m + 1
                let single_chart_data_entry = ChartDataEntry(x: Double("\(single_adafruit.iOSTime.hour).\(single_adafruit.iOSTime.minute)") ?? 0, y: single_adafruit.power)
                array_chart_data_entry.append(single_chart_data_entry)
            }
        }
        setData()
    }

    fileprivate func getChartData(){
    
        AF.request("https://adafruitapi.herokuapp.com/api/get/", method: .get).responseJSON(completionHandler: { [self]
            response in
            let api_power_results = response.value as? NSArray
            guard let _array_power_reults = api_power_results else { return  }
            array_power_results = []
            overallConsumption = 0
//            var oldtime:Date = 12.seconds.earlier
            let time_diff:Double = 12/3600
            for power_result in _array_power_reults{
                
                let json_power_result = power_result as? [String:Any]
                
                let current = json_power_result?["current"] as? String ?? ""
                let date_stamp = json_power_result?["date_stamp"] as? String
                let id = json_power_result?["id"] as? Int
                let time_stamp = json_power_result?["time_stamp"] as? String ?? ""
                let power = json_power_result?["power"] as? String ?? ""
                let voltage = json_power_result?["voltage"] as? String ?? ""

                //create datestamp formatter
                let dateStampFormatter = DateFormatter()
                dateStampFormatter.dateFormat = "yyyy-MM-dd"
                
                //create timestmap formatter
                let timeStampFormatter = DateFormatter()
                timeStampFormatter.dateFormat = "HH:mm:ss"
                
                
                //trim timestamp
                let range = time_stamp.index(time_stamp.startIndex, offsetBy: 8)..<time_stamp.index(time_stamp.startIndex, offsetBy: 15)
                let k = time_stamp.replacingCharacters(in: range, with: "")
                
                overallConsumption += (Double(power) ?? 0)
                let iOSTimeStamp = timeStampFormatter.date(from: k) ?? Date()
            
                
                let single_power = AdaFruitResult(current: Double(current) ?? 0, date_stamp: date_stamp ?? "", id: id ?? 0, power: (Double(power) ?? 0) * time_diff, time_stamp: time_stamp, voltage: Double(voltage) ?? 0, iOSDate: dateStampFormatter.date(from: date_stamp ?? "") ?? Date(), iOSTime: iOSTimeStamp)
                
                array_Dates.append(single_power.iOSDate)
                array_power_results.insert(single_power, at: 0)
            }
            
            UserDefUtils.userConsumptionPower = overallConsumption
            array_Dates = array_Dates.unique()
            sortArrayPowerResults()
            checkIfLastDataFromAPICallIsTheSameAsRealm()
//            convertToChartDataEntry(array_adafruit: array_power_results)
        })
    }
    
    fileprivate func checkIfLastDataFromAPICallIsTheSameAsRealm(){
        
        if let array_realm_persistentAdaFruit = array_realm_persistentAdaFruit{
            let hmm = Array(array_realm_persistentAdaFruit)
//            let hmmflatmap = hmm.flatMap({
//                k in k.listOfPersAdafruits
//            })
//            print(hmmflatmap)
//            print(1)
        localRealm.deleteAll()
            
        sortArrayPowerResults()
            
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
        }
        
    }
    
    func sortArrayPowerResults(){
        
        for oneDate in array_Dates{
            
            let oneArray = array_power_results.filter({
                $0.iOSDate == oneDate
            })

//            print(oneArray.count)
            let oneArrPersistentPowerResult = ArraysPersistentAdaFruit(iOSDate: oneDate)

            for chai in oneArray{
                let ah = chai.createPAdaObject()
                oneArrPersistentPowerResult.listOfPersAdafruits.append(ah)
                oneArrPersistentPowerResult.consumpitonTotal.value = (oneArrPersistentPowerResult.consumpitonTotal.value ?? 0) + (ah.power.value ?? 0)
            }
            
            try! localRealm.write {
                localRealm.add(oneArrPersistentPowerResult)
            }
            
            print(oneDate)
            
            
            if oneDate.isToday {
                todayPower = 0
                for hm in oneArray{
                    todayPower += hm.power
                }
            }
            
            array_of_array_powerResults.append(oneArray)
        }
        
        print(array_of_array_powerResults.count)
//         print(array_of_array_powerResults[0])
    }

}


extension HomeViewController: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}


extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}


extension HomeViewController: UNUserNotificationCenterDelegate{
    fileprivate func registerForNotifications(){
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }

        UIApplication.shared.registerForRemoteNotifications()

    }
}
