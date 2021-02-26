//
//  InsightPagePicker.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/18/21.
//  Copyright © 2021 Camden Developers. All rights reserved.
//

import SwiftUI

struct InsightPagePicker: View {
    @Binding var selection: InsightPage
    
    var body: some View {
        HStack {
            ForEach(InsightPage.allCases, id: \.self) { page in
                Button(page.display) { selection = page }
                    .tag(page.rawValue)
                    .foregroundColor(page == selection ? ColorPalette.color(.tint) : ColorPalette.color(.secondaryForeground))
                    .font(page == selection ? .headline : .body)
                    .scaleEffect(page == selection ? 1.05 : 1)
                
                if page != InsightPage.allCases.last {
                    Spacer()
                }
            }
        }.padding([.top, .bottom], 12)
    }
}

struct InsightPagePicker_Previews: PreviewProvider {
    static var previews: some View {
        InsightPagePicker(selection: .constant(.category))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
