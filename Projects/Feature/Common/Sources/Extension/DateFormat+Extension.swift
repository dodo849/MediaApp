//
//  DateFormat+Extension.swift
//  CommonFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

public extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: self)
    }
}
