//
//  StockModel.swift
//  StocksListApp
//
//  Created by Dogukan Berk Ozer on 21.07.2024.
//

import Foundation

struct StocksData: Codable {
    let stocksList: [Stock]
    
    enum CodingKeys: String, CodingKey {
        case stocksList = "l"
    }
}
struct Stock: Codable {
    let key: String
    let updatedTime: String
    let lastPrice: String
    let name: String?
    let percentagepriceDifference: String?
    let priceDifference: String?
    let lowestPrice: String?
    let highestPrice: String?
    let buyPrice: String?
    let sellPrice: String?
    let pdc: String?
    let ceiling: String?
    let floorPrice: String?
    let groupCode: String?
    
    
    // necessary info to update cell UI
    var priceChange: PriceChange = .unchanged
    var willBeHighlighted: Bool = false
    
    // gives meaningful and clear names to service data
    enum CodingKeys: String, CodingKey {
        case key = "tke"
        case updatedTime = "clo"
        case lastPrice = "las"
        case name = "cod"
        case percentagepriceDifference = "pdd"
        case priceDifference = "ddi"
        case lowestPrice = "low"
        case highestPrice = "hig"
        case buyPrice = "buy"
        case sellPrice = "sel"
        case pdc = "pdc"
        case ceiling = "cei"
        case floorPrice = "flo"
        case groupCode = "gco"
    }
}
