//
//  HIstoryCollectionViewCell.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 10/07/2021.
//

import UIKit
import Charts


class HistoryCVC: UICollectionViewCell {
    
    static let identifier = "HIstoryCollectionViewCell"
    
    static func getNib() -> UINib{
        return .init(nibName: identifier, bundle: nil)
    }
    
    

    @IBOutlet weak var historyLineChart: LineChartView!
    @IBOutlet weak var labelDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureChartView()
        
        // Initialization code
    }
    
    

    fileprivate func configureChartView(){
        historyLineChart.rightAxis.enabled = false
        historyLineChart.xAxis.labelTextColor = .gray
        historyLineChart.noDataText = "Downloading Chart Data..."
        historyLineChart.chartDescription?.text = "Time"
    
        let firstLegend = LegendEntry.init(label: "Power in Kwh", form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor.black)
        historyLineChart.legend.setCustom(entries: [firstLegend])
//        myLineChart.xAxis.valueFormatter =
        
    }
    
}
