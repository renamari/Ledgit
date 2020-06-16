//
//  Device.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import SystemConfiguration
import UIKit

struct Screen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(Screen.width, Screen.height)
    static let minLength = min(Screen.width, Screen.height)
}

struct Type {
    static let iphone4 = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxLength < 568.0
    static let iphone5 = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxLength == 568.0
    static let iphone7 = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxLength == 667.0
    static let iphone7P = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxLength == 736.0
    static let ipad = UIDevice.current.userInterfaceIdiom == .pad && Screen.maxLength == 1024.0
}

struct Reachability {
    static var isConnectedToNetwork: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }

        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
