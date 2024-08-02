//
//  String+Extensions.swift
//  StocksListApp
//
//  Created by Dogukan Berk Ozer on 22.07.2024.
//

import Foundation

// conversion required to compare numerical values
extension String {
    func toDouble() -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        
        if let number = formatter.number(from: self) {
            return number.doubleValue
        }
        return nil
    }
}
