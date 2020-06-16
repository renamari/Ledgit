//
//  LedgitAnalytics.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 3/14/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import Foundation

class LedgitAnalytics {
    static let shared = LedgitAnalytics()

    func logEvent(_ description: String, file: String = #file, method: String = #function) {
        let parameters: [String: Any] = [
            "description": "\(description)" as NSObject,
            "method": "\(method)" as NSObject
        ]
    }
}

extension String {
    var cleaned: String {
        guard let lastComponent = split(separator: "/").last else { return "" }
        let fullFileName = String(lastComponent)

        guard let firstComponent = fullFileName.split(separator: ".").first else { return "" }
        let cleanedFileName = String(firstComponent)

        return cleanedFileName
    }
}
