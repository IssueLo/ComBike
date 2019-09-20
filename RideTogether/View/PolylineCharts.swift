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
        
        self.chartDescription?.text = "坡度紀錄"
        
        self.xAxis.labelPosition = .bottom
        
        self.xAxis.axisMinimum = 0
        
        self.xAxis.axisMaximum = 1000
        
//        let formatterX = NumberFormatter()  //自定义格式
//        formatterX.positiveSuffix = "s"  //数字后缀
//        self.xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatterX)
        
        let xValues = ["0 km","1 km"]
        self.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        
        self.legend.form = .none
        
        let formatterY = NumberFormatter()  //自定义格式
        formatterY.positiveSuffix = " m"  //数字后缀
        self.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatterY)
        
        self.rightAxis.drawLabelsEnabled = false
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
        
        chartDataSet.drawCirclesEnabled = false
        
        chartDataSet.highlightEnabled = false
        
        chartDataSet.lineWidth = 2
        
        chartDataSet.colors = [.orange]
        
        chartDataSet.mode = .cubicBezier
        
        chartDataSet.drawValuesEnabled = false
        
        //开启填充色绘制
        chartDataSet.drawFilledEnabled = true
        //渐变颜色数组
        let gradientColors = [UIColor.orange.cgColor, UIColor.white.cgColor] as CFArray
        //每组颜色所在位置（范围0~1)
        let colorLocations:[CGFloat] = [1.0, 0.0]
        //生成渐变色
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: gradientColors, locations: colorLocations)
        //将渐变色作为填充对象s
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        
        self.xAxis.axisMinimum = 0
        
        self.xAxis.axisMaximum = Double(chartData.count)
        
        self.data = chartDataLine
    }
}
