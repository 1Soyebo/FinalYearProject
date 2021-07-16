//
//  ViewController.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 04/06/2021.
//

import UIKit
import Charts
import Alamofire
import PKHUD
//import RealmSwift
import DateToolsSwift

//2021-06-10
//18:28:29.694614

class HomeViewController: UIViewController {
    
    @IBOutlet weak var historyCollectionView: UICollectionView!
    //    let localRealm = try! Realm()
    
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var lblCurrentPower: UILabel!
    @IBOutlet weak var lblTodayConsumption: UILabel!
    @IBOutlet weak var daysPageControl: UIPageControl!
    
    
    
    
    var array_Dates = [Date]()
    var array_of_array_powerResults = [[AdaFruitResult]]()
    
//    var array_realm_persistentAdaFruit: Results<ArraysPersistentAdaFruit>?
    
//    @IBOutlet weak var myLineChart: LineChartView!
    var array_power_results = [AdaFruitResult]()
    
    var availablePower:Double = 0
    
    var todayPower:Double = 0{
        didSet{
            lblCurrentPower.text = "\(todayPower) kwH"
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
        self.title = "Energy Monitor"
        navigationController?.navigationBar.prefersLargeTitles = true
        registerForNotifications()
        setLabels()
        self.getChartData()
        configureColledtionView()
//        repeateGetREquest()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [self] in
            let o_consum2dp = String(format:"%.2f", UserDefUtils.userPurchasedPower - overallConsumption)
            lblAvailable.text = "\(o_consum2dp) kwH"
        }
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
    
    
    
    fileprivate func configureColledtionView(){
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
        historyCollectionView.register(HistoryCVC.getNib(), forCellWithReuseIdentifier: HistoryCVC.identifier)
        historyCollectionView.isPagingEnabled = true
        if let flowlayout = historyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumLineSpacing = 0
            
        }
        
    }
    
    fileprivate func calculateTotalPowerPerDay(arraySmallPower: [AdaFruitResult]){
        var totalPerDay:Double = 0
        for m in arraySmallPower{
            totalPerDay += m.power
        }
        
        let o_consum2dp = String(format:"%.2f", totalPerDay)
        lblTodayConsumption.text = "\(o_consum2dp) kwH"
        
    }
    

    fileprivate func getChartData(){
//        HUD.show(.progress)
        AF.request("https://adafruitapi.herokuapp.com/api/get/", method: .get).responseJSON(completionHandler: { [self]
            response in
            let api_power_results = response.value as? NSArray
            guard let _array_power_reults = api_power_results else { return  }
            array_power_results = []
            overallConsumption = 0
//            var oldtime:Date = 12.seconds.earlier
            let time_diff:Double = 5/3600000
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
                
                overallConsumption += (Double(power) ?? 0) * time_diff
                let iOSTimeStamp = timeStampFormatter.date(from: k) ?? Date()
            
                
                let single_power = AdaFruitResult(current: Double(current) ?? 0, date_stamp: date_stamp ?? "", id: id ?? 0, power: (Double(power) ?? 0) * time_diff, time_stamp: time_stamp, voltage: Double(voltage) ?? 0, iOSDate: dateStampFormatter.date(from: date_stamp ?? "") ?? Date(), iOSTime: iOSTimeStamp)
                
                array_Dates.append(single_power.iOSDate)
//                array_power_results.insert(single_power, at: 0)
                array_power_results.append(single_power)

            }
            
            UserDefUtils.userConsumptionPower = overallConsumption
            array_Dates = array_Dates.unique()
            sortArrayPowerResults()
//            checkIfLastDataFromAPICallIsTheSameAsRealm()
//            HUD.hide()
            historyCollectionView.reloadData()
            let hmm = IndexPath(item: array_Dates.count - 1, section: 0)
            historyCollectionView.scrollToItem(at: hmm, at: .right, animated: true)
            daysPageControl.numberOfPages = array_Dates.count
            daysPageControl.currentPage = array_Dates.count - 1



//            convertToChartDataEntry(array_adafruit: array_power_results)
        })
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
            
//            try! localRealm.write {
//                localRealm.add(oneArrPersistentPowerResult)
//            }
            
            print(oneDate)
            
            
            if oneDate.isToday {
                todayPower = 0
                for hm in oneArray{
                    todayPower += hm.power
                }
            }
            
            array_of_array_powerResults.append(oneArray)
        }
        if let firstArray = array_of_array_powerResults.first{
            calculateTotalPowerPerDay(arraySmallPower: firstArray)
        }

        print(array_of_array_powerResults.count)
//         print(array_of_array_powerResults[0])
//        convertToChartDataEntry(array_adafruit: array_of_array_powerResults[2])

    }

}


extension HomeViewController: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
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


extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if array_power_results.isEmpty{
            return 1
        }else{
            return array_Dates.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let historyCVCell = historyCollectionView.dequeueReusableCell(withReuseIdentifier: HistoryCVC.identifier, for: indexPath) as! HistoryCVC
        
        if array_power_results.isEmpty{
            return historyCVCell
        }
        
        
        historyCVCell.labelDate.text = "\(array_Dates[indexPath.item].toShortString())"
        historyCVCell.convertToChartDataEntry(array_adafruit: self.array_of_array_powerResults[indexPath.item])
        return historyCVCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: historyCollectionView.frame.width, height: historyCollectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPageNumber = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        calculateTotalPowerPerDay(arraySmallPower: array_of_array_powerResults[currentPageNumber])
        daysPageControl.currentPage = currentPageNumber
    }
    
}
