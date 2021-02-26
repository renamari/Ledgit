//
//  ViewModel.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/17/21.
//  Copyright © 2021 Camden Developers. All rights reserved.
//

import Foundation
import Combine

public protocol ViewModel: ObservableObject {
    associatedtype ActionDelegate
    associatedtype Action
    
    var actionDelegate: ActionDelegate? { get set }
    var cancellables: Set<AnyCancellable> { get set }
    
    func send(_ action: Action)
}
