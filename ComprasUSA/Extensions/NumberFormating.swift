//
//  UIViewController+CoreData.swift
//  FlavioMarceloMarinaldoTiago
//
//  Created by Flavio Caruso, Marcelo Mussi, Marinaldo Ferreira and Tiago Vaz on 16/02/23.
//

import Foundation

extension Double {
    private func formatValue(decimalSeparator: String, groupingSeparator: String) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.alwaysShowsDecimalSeparator = true
        formatter.decimalSeparator = decimalSeparator
        formatter.groupingSeparator = groupingSeparator
        
        return formatter.string(from: NSNumber(value: self))!
    }
    
    func usdValue() -> String {
        return formatValue(decimalSeparator: ".", groupingSeparator: ",")
    }
    
    func brlValue() -> String {
        return formatValue(decimalSeparator: ",", groupingSeparator: ".")
    }
}
