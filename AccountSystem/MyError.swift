//
//  MyError.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import Foundation

enum MyError: LocalizedError {
    case custom(errorDescription: String)

    var errorDescription: String? {
        switch self {
        case .custom(let errorDescription):
            return errorDescription
        }
    }
    
}
