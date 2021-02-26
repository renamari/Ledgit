//
//  WeeklyChartView.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/18/21.
//  Copyright © 2021 Camden Developers. All rights reserved.
//

import SwiftUI
import Charts

struct WeeklyChartView: UIViewRepresentable {
    func makeUIView(context: Context) -> BarChartView {
        let chart = BarChartView()
        chart.dragEnabled = false
        //chart.delegate = self
        chart.noDataTextAlignment = .center
        chart.noDataFont = .futuraMedium14
        chart.noDataTextColor = LedgitColor.coreBlue
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.scaleXEnabled = false
        chart.scaleYEnabled = false
        chart.noDataText = Constants.ChartText.noWeeklyActivity
        chart.noDataTextAlignment = .center
        return chart
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        
    }
}

struct WeeklyChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyChartView()
    }
}
