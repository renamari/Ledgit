//
//  WeeklyCollectionViewCell.swift
//  Ledgit
//
//  Created by Camden Madina on 8/18/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

class WeeklyCollectionViewCell: UICollectionViewCell, ChartViewDelegate {
    @IBOutlet weak var weeklyChart: BarChartView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayCostLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    var weekdays:[String] = [
        (Date() - 6.day).toString(withFormat: "E"),
        (Date() - 5.day).toString(withFormat: "E"),
        (Date() - 4.day).toString(withFormat: "E"),
        (Date() - 3.day).toString(withFormat: "E"),
        (Date() - 2.day).toString(withFormat: "E"),
        (Date() - 1.day).toString(withFormat: "E"),
        "Today"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        weeklyChart.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width:0,height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.10
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
    }
    
    func updateLabels(dayAmount: Double, budgetAmount: Double, remainingAmount: Double, averageAmount: Double){
        
        let dayAmount = String(format: "%.2f", dayAmount)
        let budgetAmount = String(format: "%.2f", budgetAmount)
        let remainingAmount = String(format: "%.2f", remainingAmount)
        let averageAmount = String(format: "%.2f", averageAmount)
        
        
        dayLabel.text = Date().toString(withFormat: "EEEE, MMM d")
        dayCostLabel.text =  dayAmount
        budgetLabel.text =  budgetAmount
        remainingLabel.text =  remainingAmount
        averageLabel.text =  averageAmount
    }
    
    func setupChart(with data: [Entry]){
        guard !data.isEmpty else{
            return
        }
        
        var values:[BarChartDataEntry] = []
        var amounts:[Double] = [0, 0, 0, 0, 0, 0, 0]
        
        for index in 0..<data.count{
            let item = data[index]
            
            if item.date.isInSameDayOf(date: (Date() - 6.day)){
                amounts[0] += item.cost
            }else if item.date.isInSameDayOf(date: (Date() - 5.day)){
                amounts[1] += item.cost
            }else if item.date.isInSameDayOf(date: (Date() - 4.day)){
                amounts[2] += item.cost
            }else if item.date.isInSameDayOf(date: (Date() - 3.day)){
                amounts[3] += item.cost
            }else if item.date.isInSameDayOf(date: (Date() - 2.day)){
                amounts[4] += item.cost
            }else if item.date.isInSameDayOf(date: (Date() - 1.day)){
                amounts[5] += item.cost
            }else if item.date.isToday{
                amounts[6] += item.cost
            }
        }
        
        for index in 0..<amounts.count{
            let entry = BarChartDataEntry(x: Double(index), y: amounts[index])
            values.append(entry)
        }
        
        drawChart(with: values)
    }
    
    fileprivate func drawChart(with values: [BarChartDataEntry]){
        weeklyChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutBack)
        
        let format = NumberFormatter()
        format.minimum = 0
        format.numberStyle = .currency
        format.allowsFloats = false
        format.currencySymbol = Model.model.currentUser!.homeCurrency.symbol
        
        let xFormat = BarChartXAxisFormatter(labels: weekdays)
        
        let dataFormat = NumberFormatter()
        dataFormat.numberStyle = .currency
        dataFormat.allowsFloats = false
        dataFormat.zeroSymbol = ""
        dataFormat.currencySymbol = Model.model.currentUser!.homeCurrency.symbol
        let dataFormatter = DefaultValueFormatter(formatter: dataFormat)
        
        let xAxis: XAxis = weeklyChart.xAxis
        xAxis.labelPosition = .bottom;
        xAxis.labelFont = .futuraMedium10
        xAxis.labelTextColor = .kColor3F6072
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0 // only intervals of 1 day
        xAxis.labelCount = 7
        xAxis.valueFormatter = xFormat
        
        let leftAxis: YAxis = weeklyChart.leftAxis
        leftAxis.labelTextColor = .kColor3F6072
        leftAxis.labelFont = .futuraMedium8
        leftAxis.labelPosition = .outsideChart
        leftAxis.axisMinimum = 0.0
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: format)
        leftAxis.drawGridLinesEnabled = false
        leftAxis.gridColor = .kColorF2F5F7
        leftAxis.gridLineWidth = 1.0
        
        let dataSet = BarChartDataSet(values: values, label: nil)
        dataSet.colors = [.kColor2C82BE]
        
        let data = BarChartData(dataSet: dataSet)
        data.setValueFormatter(dataFormatter)
        data.setValueFont(.futuraMedium8)
        data.setValueTextColor(.kColor4E4E4E)
        
        weeklyChart.data = data
        weeklyChart.rightAxis.enabled = false
        weeklyChart.legend.enabled = false
        weeklyChart.chartDescription = nil
        weeklyChart.highlightPerTapEnabled = false
    }
}

extension WeeklyCollectionViewCell {
    
    class BarChartXAxisFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
}