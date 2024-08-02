//
//  PageModels.swift
//  StocksListApp
//
//  Created by Dogukan Berk Ozer on 19.07.2024.
//

import Foundation

struct PageData: Codable {
    let stockInfoList: [StockInfo]
    let columnDataList: [ColumnData]
    
    enum CodingKeys: String, CodingKey {
        case stockInfoList = "mypageDefaults"
        case columnDataList = "mypage"
    }
}

struct StockInfo: Codable {
    let name: String
    let gro: String
    let key: String
    let def: String
    
    enum CodingKeys: String, CodingKey {
        case name = "cod"
        case gro = "gro"
        case key = "tke"
        case def = "def"
    }
}

struct ColumnData: Codable {
    let name: String
    let key: String
}
