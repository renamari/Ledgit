//
//  ResourceManager.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 1/21/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import Foundation

class ResourceManager {
    
    // MARK: - Properties
    static let shared = ResourceManager()
    private var request: NSBundleResourceRequest?
    var bundle: Bundle = Bundle.main
    var retrievedFlags = false
    
    // MARK: - Methods
    func requestFlagImages() {
        request = NSBundleResourceRequest(tags: ["flags"])
        
        guard let request = request else { return }
        request.endAccessingResources()
        
        request.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
        
        request.beginAccessingResources { error in
            if let error = error {
                print( error.localizedDescription )
                self.retrievedFlags = false
            }
            
            self.bundle = request.bundle
            self.retrievedFlags = true
        }
    }
}
