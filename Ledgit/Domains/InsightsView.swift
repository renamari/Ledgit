//
//  InsightsView.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/18/21.
//  Copyright © 2021 Camden Developers. All rights reserved.
//

import SwiftUI

enum InsightPage: Int, CaseIterable {
    case summary
    case category
    case history
    
    var display: String {
        switch self {
        case .summary:
            return "Summary"
        case .category:
            return "Category"
        case .history:
            return "History"
        }
    }
}

struct InsightsView: View {
    @SwiftUI.State var page: InsightPage = .summary
    
    var createExpenseButton: some View {
        Button(action: {}) {
            Image(systemName: "plus").imageScale(.large)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            InsightPagePicker(selection: $page)
                .padding([.leading, .trailing])
            
            TabView(selection: $page) {
                ForEach(InsightPage.allCases, id: \.self) { page in
                    switch page {
                    case .summary:
                        SummaryView()
                    case .category:
                        Text(page.display)
                    case .history:
                        Text(page.display)
                    }
                }.animation(.none)
                .background(ColorPalette.color(.secondaryBackground).edgesIgnoringSafeArea(.all))
                .cornerRadius(8)
                .padding()
                .shadow(radius: 8)
            }.animation(.linear)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
        }.background(ColorPalette.color(.primaryBackground).edgesIgnoringSafeArea(.all))
        .navigationBarItems(trailing: createExpenseButton)
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InsightsView()
            
            InsightsView().environment(\.colorScheme, .dark)
        }
    }
}
