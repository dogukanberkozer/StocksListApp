//
//  Contracts.swift
//  StocksListApp
//
//  Created by Dogukan Berk Ozer on 19.07.2024.
//

import Foundation

// delegation that provides communication between ListStocksViewController and ListStocksViewModel
protocol ListStocksViewModelDelegate: AnyObject {
    func didFetchPageData(columnDataList: [ColumnData])
    func didFetchStocks(updatedStockList: [Stock])
}

// data structure that holds column values ​​on the screen
struct ColumnKeys: Codable {
    var firstColumnKey: String
    var secondColumnKey: String
}

// stock price may increase, decrease or remain unchanged
enum PriceChange {
    case rise
    case unchanged
    case fall
}
