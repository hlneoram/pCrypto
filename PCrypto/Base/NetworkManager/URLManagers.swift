//
//  URLManagers.swift
//  PCrypto
//
//  Created by Ram Sharma on 16/03/22.
//  

import Foundation

enum Endpoint: CustomStringConvertible {
    case coins(page: Int)
    
    var description: String {
        switch self {
        case .coins(page: let page):
            return "/api/v3/mobile-app/explore/asset-tiles-by-category?category=cryptocurrency&page=\(page)&pageSize=10&sortKey=name"
        }
    }
}

