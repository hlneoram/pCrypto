//
//  SocketModel.swift
//  PCrypto
//
//  Created by Ram Sharma on 17/03/22.
//

import Foundation

struct SocketPriceChangeResponseModel: Decodable {
    let currentPrice : SocketPriceChangeModel?
}

struct SocketPriceChangeModel: Decodable {
    let priceChange: Int?
    let priceChangePercent: Double?
    let cryptocurrencySymbol: String?
}
