//
//  PolylineCharts.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/16.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import Charts

class UserPolylineView: LineChartView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.xAxis.labelPosition = .bottomInside
        
        self.xAxis.axisLineWidth = 1
        
        self.xAxis.axisLineColor = .red
        
        self.xAxis.axisMinimum = 0
        
        self.xAxis.axisMaximum = 1000
        
        self.xAxis.drawGridLinesEnabled = false
        
    }
    
    func updateChartsData(_ chartData: [Double]) {
        
        var dataEntries = [ChartDataEntry]()
        
        for number in 0..<chartData.count {
            
            let numberY = chartData[number]
            
            let entry = ChartDataEntry.init(x: Double(number), y: Double(numberY))
            
            dataEntries.append(entry)
        }
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        //目前折线图只包括1根折线
        let chartDataLine = LineChartData(dataSets: [chartDataSet])
        
        self.xAxis.axisMinimum = 0
        
        self.xAxis.axisMaximum = Double(chartData.count)
        
        self.data = chartDataLine
    }
}
