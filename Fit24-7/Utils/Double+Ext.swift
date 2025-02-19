//
//  Double+Ext.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 19/02/25.
//

import Foundation

extension Double {
    
    func formattedNumberString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
}
