//
//  CategoryCollectionViewCell.swift
//  Ledgit
//
//  Created by Camden Madina on 8/18/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import Charts

class CategoryCollectionViewCell: UICollectionViewCell, ChartViewDelegate {
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var displayButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pieChart.delegate = self

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
        layer.shadowOpacity = 0.05
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
    }
    
    func setupChart(with data: [Entry]){
        guard !data.isEmpty else{
            return
        }
        
        var categories:[String:Double] = [:]
        var values:[PieChartDataEntry] = []
        
        for item in data{
            if categories.keys.contains(item.category){
                categories[item.category]! += item.cost
            }else{
                categories[item.category] = item.cost
            }
        }
        
        for item in categories{
            let entry = PieChartDataEntry(value: item.value, label: item.key)
            values.append(entry)
        }
        
        drawChart(with: values)
    }
    
    fileprivate func drawChart(with values: [PieChartDataEntry]){
        let legend:Legend = pieChart.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = true
        legend.xEntrySpace = 7.0
        legend.yEntrySpace = 0.0
        legend.yOffset = 0.0
        legend.textColor = .kColor4E4E4E
        
        pieChart.chartDescription = nil
        pieChart.usePercentValuesEnabled = true
        pieChart.drawSlicesUnderHoleEnabled = false
        pieChart.holeRadiusPercent = 0.60
        pieChart.transparentCircleRadiusPercent = 1
        pieChart.drawCenterTextEnabled = true
        pieChart.drawHoleEnabled = true
        pieChart.rotationAngle = 0.0
        pieChart.rotationEnabled = false
        pieChart.highlightPerTapEnabled = false
        pieChart.entryLabelColor = .white
        pieChart.entryLabelFont = UIFont(name: "HelveticaNeue-Light", size: 12)
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeInOutBack)
        
        let dataSet = PieChartDataSet(values: values, label: nil)
        dataSet.drawIconsEnabled = false
        dataSet.sliceSpace = 2.0
        dataSet.colors = [.kColor003559,.kColor061A40,.kColorB9D6F2,.kColor76DDFB,.kColor2C82BE]
        
        let data = PieChartData(dataSet: dataSet)
        let format = NumberFormatter()
        format.numberStyle = .percent
        format.maximumFractionDigits = 1
        format.multiplier = 1.0
        format.percentSymbol = "%"
        let formatter = DefaultValueFormatter(formatter: format)
        data.setValueFormatter(formatter)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 12))
        data.setValueTextColor(.kColor4E4E4E)
        dataSet.yValuePosition = .insideSlice
        
        pieChart.data = data
        pieChart.highlightValues(nil)
    }
    
    @IBAction func displayButtonPressed(_ sender: Any) {
        switch displayButton.currentTitle!{
        case "$":
            let format = NumberFormatter()
            format.numberStyle = .percent
            format.maximumFractionDigits = 1
            format.multiplier = 1.0
            format.percentSymbol = "%"
            let formatter = DefaultValueFormatter(formatter: format)
            
            pieChart.data?.setValueFormatter(formatter)
            pieChart.usePercentValuesEnabled = true
            displayButton.setTitle("%", for: .normal)
        default:
            let format = NumberFormatter()
            format.numberStyle = .currency
            format.currencySymbol = Model.model.currentUser!.homeCurrency.symbol
            let formatter = DefaultValueFormatter(formatter: format)
            
            pieChart.data?.setValueFormatter(formatter)
            pieChart.usePercentValuesEnabled = false
            displayButton.setTitle("$", for: .normal)
        }
        
        
    }
}
