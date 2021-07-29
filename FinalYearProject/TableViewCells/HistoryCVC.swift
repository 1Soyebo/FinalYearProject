//
//  HIstoryCollectionViewCell.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 10/07/2021.
//

import UIKit
import Charts
import SkeletonView

class HistoryCVC: UICollectionViewCell {
    
    static let identifier = "HIstoryCollectionViewCell"
    
    static func getNib() -> UINib{
        return .init(nibName: identifier, bundle: nil)
    }
    
    var array_chart_data_entry = [ChartDataEntry]()


    @IBOutlet weak var historyLineChart: LineChartView!
    @IBOutlet weak var labelDate: UILabel!
    
    var firstcChartLegend: LegendEntry!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureChartView()

    }
    
    
    

    fileprivate func configureChartView(){
        historyLineChart.rightAxis.enabled = false
        historyLineChart.xAxis.labelTextColor = .gray
        historyLineChart.noDataText = "Downloading Chart Data..."
        historyLineChart.chartDescription?.text = "Time"
        
        
        firstcChartLegend = LegendEntry.init(label: "Power in Kwh", form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UserDefUtils.userChartTintColor)
        historyLineChart.legend.setCustom(entries: [firstcChartLegend])
//        myLineChart.xAxis.valueFormatter =
        
    }
    
    func changeLegendColor(theColor: UIColor){
        historyLineChart.legend.textColor = theColor
        firstcChartLegend.formColor = theColor
    }
    
    fileprivate func setData(){
        let set1 = LineChartDataSet(entries: array_chart_data_entry)
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.fillColor = .black
        set1.mode = .linear
        set1.fillAlpha = 0.2
        set1.fill = Fill(color: .gray)
        set1.drawFilledEnabled = false
        set1.setColor(UserDefUtils.userChartTintColor)
        
        
        let data = LineChartData(dataSet: set1)
    
        data.setDrawValues(false)
        
        historyLineChart.data = data
    }
    
    func convertToChartDataEntry(array_adafruit: [AdaFruitResult]){
        var m = 0.0
        array_chart_data_entry = []
        if array_adafruit.count > 0{
            for single_adafruit in array_adafruit{
                m = m + 1
                let single_chart_data_entry = ChartDataEntry(x:m, y: single_adafruit.power)
                array_chart_data_entry.append(single_chart_data_entry)
                historyLineChart.xAxis.valueFormatter = DateValueFormatter(objects: array_adafruit)
            }
        }
        setData()
    }
    
}
