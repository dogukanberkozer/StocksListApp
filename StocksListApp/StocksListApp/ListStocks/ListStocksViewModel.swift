//
//  ListStocksViewModel.swift
//  StocksListApp
//
//  Created by Dogukan Berk Ozer on 19.07.2024.
//

import Foundation

final class ListStocksViewModel {
    
    // MARK: - Delegates
    
    weak var delegate: ListStocksViewModelDelegate?
    
    // MARK: - Privates
    
    private let pageUrlString: String = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterviewSettings"
    private var pageData: PageData?
    private var stocksKeysList: [String] = []
    
    // MARK: - Service Calls
    
    func prepare() {
        fetchPageData()
    }
    
    private func fetchPageData() {
        fetchData(from: pageUrlString, decodeType: PageData.self) { result in
            switch result {
            case .success(let response):
                self.pageData = response
                for stock in response.stockInfoList {
                    self.stocksKeysList.append(stock.key) // stock keys required for stock service
                }
                self.delegate?.didFetchPageData(columnDataList: self.pageData?.columnDataList ?? []) // passed to ListStocksViewController where pageData structure created
            case .failure(let error):
                print("Failed to fetch page data \n🔻 ERROR 🔻 \n\(error)")
            }
        }
    }
    
    func fetchStocksData(columnKeys: ColumnKeys, reRequest: Bool = false) {
        var stocksUrl: String = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterview?fields=\(columnKeys.firstColumnKey),\(columnKeys.secondColumnKey)&stcs=\(self.stocksKeysList.joined(separator: "~"))"
        
        // MARK: - codes from here to "TEST ENDS" mark may not be used. purpose of this code block is to experience operations of the application more clearly and accurately
        var tempStockKeys: [String] = []
        for key in self.stocksKeysList {
            if Int.random(in: 0...2) == 0 {
                tempStockKeys.append(key)
            }
        }
        if Int.random(in: 0...2) == 0 {
            tempStockKeys.append("GARAN.E.BIST")
        }
        reRequest ? stocksUrl = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterview?fields=\(columnKeys.firstColumnKey),\(columnKeys.secondColumnKey)&stcs=\(tempStockKeys.joined(separator: "~"))" : nil
        // MARK: - TEST ENDS
        
        fetchData(from: stocksUrl, decodeType: StocksData.self) { result in
            switch result {
            case .success(let response):
                self.delegate?.didFetchStocks(updatedStockList: response.stocksList) // passed to ListStocksViewController where stocksList structure created
            case .failure(let error):
                print("Failed to fetch stocks data \n🔻 ERROR 🔻 \n\(error)")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func fetchData<T: Decodable>(from url: String, decodeType: T.Type, completion: @escaping (Result<T, Error>) -> Void) { // generic(decodable) method that provides commonly used checks for all service types
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "🔻 ERROR 🔻 \nInvalid URL", code: -1, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error)) // URLSession error
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "🔻 ERROR 🔻 \nData is EMPTY!", code: -1, userInfo: nil)))
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error)) // Decoding process error
            }
        }
        task.resume()
    }
}
