//
//  Date + Ext.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 21/12/21.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
