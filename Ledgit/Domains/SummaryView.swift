//
//  SummaryView.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/18/21.
//  Copyright © 2021 Camden Developers. All rights reserved.
//

import SwiftUI

struct SummarAmountView: View {
    let alignment: HorizontalAlignment
    let title: String
    let amount: String
    
    var body: some View {
        VStack(alignment: alignment) {
            Text(title)
                .font(.footnote)
                .foregroundColor(ColorPalette.color(.secondaryForeground))
            Text(amount)
                .font(.body)
                .foregroundColor(ColorPalette.color(.primaryForeground))
                .bold()
        }
    }
}

struct SummaryView: View {
    var body: some View {
        VStack {
            Text("February 18, 2021")
                .font(.title3)
                .foregroundColor(ColorPalette.color(.primaryForeground))
                .bold()
            
            WeeklyChartView()
            
            VStack(spacing: 16) {
                HStack {
                    SummarAmountView(alignment: .leading, title: "Total Today", amount: "$0.00")
                    Spacer()
                    
                    SummarAmountView(alignment: .trailing, title: "Daily Average", amount: "$0.00")
                }
                
                HStack {
                    SummarAmountView(alignment: .leading, title: "Daily Budget", amount: "$300.00")
                    Spacer()
                    SummarAmountView(alignment: .trailing, title: "Remaining Today", amount: "$0.00")
                }
                
                HStack {
                    SummarAmountView(alignment: .leading, title: "Total Trip Cost", amount: "$0.00")
                    Spacer()
                    SummarAmountView(alignment: .trailing, title: "Estimated Final Cost", amount: "$0.00")
                }
            }
        }.padding()
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
