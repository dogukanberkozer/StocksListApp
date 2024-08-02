//
//  ListStocksViewController+Extensions.swift
//  StocksListApp
//
//  Created by Dogukan Berk Ozer on 22.07.2024.
//

import UIKit

// MARK: - TableView DataSource

extension ListStocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stocksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = stocksTableView.dequeueReusableCell(withIdentifier: "ricell", for: indexPath) as? StockTableViewCell else {
            fatalError("🔻 ERROR 🔻 \nDequeued cell is NOT an instance of StockTableViewCell")
        }
        
        cell.nameLabel.text = stocksList[indexPath.row].name ?? stocksList[indexPath.row].key.components(separatedBy: ".").first
        cell.updatedTimeLabel.text = stocksList[indexPath.row].updatedTime
        
        // configures first column value of the stock
        let firstColumntext = requestedColumnValue(stock: stocksList[indexPath.row],
                                                   columnKey: selectedColumnKeys.firstColumnKey)
        cell.firstColumnLabel.textColor = selectColor(value: firstColumntext, columnKey: selectedColumnKeys.firstColumnKey)
        cell.firstColumnLabel.text = selectedColumnKeys.firstColumnKey == "pdd" ? "%\(firstColumntext)" : firstColumntext
        
        // configures second column value of the stock
        let secondColumntext = requestedColumnValue(stock: stocksList[indexPath.row],
                                                    columnKey: selectedColumnKeys.secondColumnKey)
        cell.secondColumnLabel.textColor = selectColor(value: secondColumntext, columnKey: selectedColumnKeys.secondColumnKey)
        cell.secondColumnLabel.text = selectedColumnKeys.secondColumnKey == "pdd" ? "%\(secondColumntext)" : secondColumntext
        
        // preparation of image representing the price change within the cell
        switch stocksList[indexPath.row].priceChange {
        case .rise:
            cell.trendImageView.image = UIImage(systemName: "chevron.up")
            cell.trendImageView.backgroundColor = .systemGreen
        case .fall:
            cell.trendImageView.image = UIImage(systemName: "chevron.down")
            cell.trendImageView.backgroundColor = .systemRed
        default:
            cell.trendImageView.image = .none
            cell.trendImageView.backgroundColor = stocksList[indexPath.row].willBeHighlighted ? .gray : .darkGray
        }
        
        // determining which cells to highlight
        cell.backgroundColor = stocksList[indexPath.row].willBeHighlighted ? .gray : .darkGray
        stocksList[indexPath.row].willBeHighlighted = false // after cell highlight information is given, highlight Bool value of the stock is set to the default value in preparation for the next service call
        
        return cell
    }
}

// MARK: - ViewModel Delegate

extension ListStocksViewController: ListStocksViewModelDelegate {
    func didFetchPageData(columnDataList: [ColumnData]) {
        self.columnDataList = columnDataList
        configureHeaderButtons()
        self.selectedColumnKeys = ColumnKeys(firstColumnKey: columnDataList[0].key, secondColumnKey: columnDataList[1].key) // first two column values ​​shown by default
    }
    
    func didFetchStocks(updatedStockList: [Stock]) {
        for updatedStock in updatedStockList {
            if let existingIndex = stocksList.firstIndex(where: { $0.key == updatedStock.key }) { // to update currently displayed stock values
                
                let previousPrice = stocksList[existingIndex].lastPrice.toDouble() ?? 0.0
                let updatedPrice = updatedStock.lastPrice.toDouble() ?? 0.0
                
                stocksList[existingIndex] = updatedStock
                
                // creating necessary reference to configure stock cell image
                if previousPrice == updatedPrice {
                    stocksList[existingIndex].priceChange = .unchanged
                } else if previousPrice < updatedPrice {
                    stocksList[existingIndex].priceChange = .rise
                } else {
                    stocksList[existingIndex].priceChange = .fall
                }
                
                stocksList[existingIndex].willBeHighlighted = true // this stock cell is highlighted because used in the last service call
            } else { // case for non-default stocks such as "GARAN.E.BIST"
                stocksList.append(updatedStock)
            }
        }
        DispatchQueue.main.async { // UI operations of stocks table view must be on the main thread
            self.stocksTableView.reloadData()
        }
    }
}
