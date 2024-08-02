//
//  ViewController.swift
//  StocksListApp
//
//  Created by Dogukan Berk Ozer on 18.07.2024.
//

import UIKit

final class ListStocksViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var stocksTableView: UITableView!
    @IBOutlet weak var firstColumnButton: UIButton! // first header button
    @IBOutlet weak var secondColumnButton: UIButton! // second header button
    
    // MARK: - Privates
    
    private let viewModel: ListStocksViewModel = ListStocksViewModel()
    private var timer: Timer? // variable required to run stocks service every second
    private var popUpButtonsDataSource: [String] = [] // titles of header buttons
    
    // MARK: - Internals
    
    var selectedColumnKeys: ColumnKeys = ColumnKeys(firstColumnKey: "", secondColumnKey: "") {
        didSet { // when column info is changed, goes to stocks data service with dynamic parameters and gets the required values
            self.viewModel.fetchStocksData(columnKeys: self.selectedColumnKeys)
        }
    }
    var columnDataList: [ColumnData] = [] // column names and keys
    var stocksList: [Stock] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewModel
        viewModel.delegate = self
        viewModel.prepare()
        
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate() // lifecycle viewWillDisappear func overrided to prevent repeated service execution before operations are completed, so reduces possibility of repeated unnecessary service calls
    }
    
    // MARK: - UI
    
    func configureHeaderButtons() {
        for columnData in columnDataList {
            self.popUpButtonsDataSource.append(columnData.name) // preparing of buttons titles
        }
        setupFirstColumnButton()
        setupSecondColumnButton()
    }
    
    private func setupFirstColumnButton() {
        let firstButtonAction = { (action: UIAction) in
            self.selectedColumnKeys.firstColumnKey = self.columnNameToKey(name: action.title) // selected column value changed and stocks service will be run to get updated first column data
        }
        
        var firstMenuBreakdown: [UIMenuElement] = []
        for name in self.popUpButtonsDataSource {
            firstMenuBreakdown.append(UIAction(title: name, handler: firstButtonAction)) // actions are assigned for first button breakdowns
        }
        
        DispatchQueue.main.async { // UI operations of first button must be on the main thread
            self.firstColumnButton.menu = UIMenu(options: .displayInline, children: firstMenuBreakdown)
            self.firstColumnButton.showsMenuAsPrimaryAction = true
            self.firstColumnButton.changesSelectionAsPrimaryAction = true
        }
    }
    
    private func setupSecondColumnButton() {
        let secondButtonAction = { (action: UIAction) in
            self.selectedColumnKeys.secondColumnKey = self.columnNameToKey(name: action.title) // selected column value changed and stocks service will be run to get updated second column data
        }
        
        var secondMenuBreakdown: [UIMenuElement] = []
        for name in self.popUpButtonsDataSource {
            name == self.popUpButtonsDataSource[1] ? secondMenuBreakdown.append(UIAction(title: name, state: .on, handler: secondButtonAction)) : secondMenuBreakdown.append(UIAction(title: name, handler: secondButtonAction)) // actions are assigned for second button breakdowns
        }
        
        DispatchQueue.main.async { // UI operations of second button must be on the main thread
            self.secondColumnButton.menu = UIMenu(options: .displayInline, children: secondMenuBreakdown)
            self.secondColumnButton.showsMenuAsPrimaryAction = true
            self.secondColumnButton.changesSelectionAsPrimaryAction = true
        }
    }
    
    // MARK: - Timer Funcs
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true) // timer has been started and action assigned
    }
    
    @objc func timerFired() {
        // service runs again to update stocks data every second
        viewModel.fetchStocksData(columnKeys: self.selectedColumnKeys, reRequest: true) // additionally "reRequest" parameter ensures that stock service parameters are in different combinations to create nice experience in simulator. ListStocksViewModel's fetchStocksData func could be examined for detail
    }
    
    // MARK: - Helper Methods
    
    private func columnNameToKey(name: String) -> String { // allows to easily find the key of the new column value when it changes
        var selectedColumnKey: String?
        for columnData in self.columnDataList {
            columnData.name == name ? selectedColumnKey = columnData.key : nil
        }
        return selectedColumnKey ?? ""
    }
    
    func requestedColumnValue(stock: Stock, columnKey: String) -> String { // takes stock and column key and returns the required value to be displayed in cell
        switch columnKey {
        case Stock.CodingKeys.lastPrice.rawValue:
            return stock.lastPrice
        case Stock.CodingKeys.percentagepriceDifference.rawValue:
            return stock.percentagepriceDifference ?? ""
        case Stock.CodingKeys.priceDifference.rawValue:
            return stock.priceDifference ?? ""
        case Stock.CodingKeys.lowestPrice.rawValue:
            return stock.lowestPrice ?? ""
        case Stock.CodingKeys.highestPrice.rawValue:
            return stock.highestPrice ?? ""
        case Stock.CodingKeys.buyPrice.rawValue:
            return stock.buyPrice ?? ""
        case Stock.CodingKeys.sellPrice.rawValue:
            return stock.sellPrice ?? ""
        case Stock.CodingKeys.pdc.rawValue:
            return stock.pdc ?? ""
        case Stock.CodingKeys.ceiling.rawValue:
            return stock.ceiling ?? ""
        case Stock.CodingKeys.floorPrice.rawValue:
            return stock.floorPrice ?? ""
        case Stock.CodingKeys.groupCode.rawValue:
            return stock.groupCode ?? ""
        default:
            return ""
        }
    }
    
    func selectColor(value: String, columnKey: String) -> UIColor { // sets colors of the text in the required column value
        var colour: UIColor = .white
        guard let doubleValue = value.toDouble() else { return colour }
        
        if columnKey == "pdd" || columnKey == "ddi" {
            colour = doubleValue < 0 ? .systemRed : .systemGreen
        }
        return colour
    }
}
