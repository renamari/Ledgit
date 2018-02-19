//
//  Configuration.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/18/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit
import Firebase

enum ValueKey: String {
    case appPrimaryColor
}

class Configuration {
    static let shared = Configuration()
    private let configuration = RemoteConfig.remoteConfig()
    
    private init() {
        setupDefaults()
        setupFirebaseValues()
    }
    
    func setupDefaults() {
        let defaults: [String: NSObject] = [
            ValueKey.appPrimaryColor.rawValue : "#FBB03B" as NSObject
        ]
        configuration.setDefaults(defaults)
    }
    
    func setupFirebaseValues() {
        #if DEBUG
            let fetchDuration: TimeInterval = 0
            activateDebugMode()
        #else
            let fetchDuration: TimeInterval = 43200
        #endif
        
        configuration.fetch(withExpirationDuration: fetchDuration) { [unowned self] (status, error) in
            if let error = error {
                Log.error(error)
                return
            }
    
            Log.info("Retrieved values from the Firebase")
            self.configuration.activateFetched()
        }
    }
    
    func activateDebugMode() {
        guard let debugSettings = RemoteConfigSettings(developerModeEnabled: true) else { return }
        configuration.configSettings = debugSettings
    }
}

extension Configuration {
    /*
    func color(for key: ValueKey) -> UIColor {
        let hexString = configuration[key.rawValue].stringValue ?? "#FFFFFFFF"
        let convertedColor = UIColor(//UIColor(//UIColor(rgba: hexString)
        return convertedColor
    }
 */
    func bool(for key: ValueKey) -> Bool {
        return configuration[key.rawValue].boolValue
    }
    
    func string(for key: ValueKey) -> String {
        return configuration[key.rawValue].stringValue ?? ""
    }
    
    func double(for key: ValueKey) -> Double {
        if let numberValue = configuration[key.rawValue].numberValue {
            return numberValue.doubleValue
        } else {
            return 0.0
        }
    }
}
