//
//  Result.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 3/3/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
