//
//  ViewController.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 04/06/2021.
//

import UIKit
import Charts
import Alamofire

//2021-06-10
//18:28:29.694614

class HomeViewController: UIViewController {
    
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var lblCurrentPower: UILabel!
    @IBOutlet weak var lblTodayConsumption: UILabel!
    
    
    @IBOutlet weak var myLineChart: LineChartView!
    var array_power_results = [AdaFruitResult]()
    var array_chart_data_entry = [ChartDataEntry]()
    
    var availablePower:Double = 0
    var todayPower:Double = 0
    var currentPower:Double = 0
    var overallConsumption:Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        getChartData()
        lblAvailable.text = "0 kwH"
        lblCurrentPower.text = "0 kwH"
        lblTodayConsumption.text = "0 kwH"

    }
    
    fileprivate func setData(){
        let set1 = LineChartDataSet(entries: array_chart_data_entry)
        let data = LineChartData(dataSet: set1)
        myLineChart.data = data
        
        lblCurrentPower.text = "\(overallConsumption) kwH"
    }
    
    fileprivate func convertToChartDataEntry(){
        var m = 0.0
        for single_adafruit in array_power_results{
            m = m + 1
            let single_chart_data_entry = ChartDataEntry(x: m, y: single_adafruit.power)
            array_chart_data_entry.append(single_chart_data_entry)
        }
        setData()

    }

    fileprivate func getChartData(){
    
        AF.request("https://adafruitapi.herokuapp.com/api/get/", method: .get).responseJSON(completionHandler: { [self]
            response in
            print(response.value as? NSArray as Any)
            let api_power_results = response.value as? NSArray
            guard let _array_power_reults = api_power_results else { return  }
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
                
                overallConsumption = overallConsumption + (Double(power ?? "") ?? 0)
                
                let single_power = AdaFruitResult(current: Double(current) ?? 0, date_stamp: date_stamp ?? "", id: id ?? 0, power: Double(power) ?? 0, time_stamp: time_stamp, voltage: Double(voltage) ?? 0, iOSDate: dateStampFormatter.date(from: date_stamp ?? "") ?? Date(), iOSTime: timeStampFormatter.date(from: k) ?? Date())
                array_power_results.append(single_power)
            }
            
            let hmFormatter = DateFormatter()
            hmFormatter.timeStyle = .short
            lblCurrentPower.text = hmFormatter.string(from: array_power_results.last?.iOSTime ?? Date())
            
            convertToChartDataEntry()
        })
    }

}


extension HomeViewController: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}


