//
//  Date+Extension.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/04.
//

import Foundation

extension Date {
    func dayOfTheWeek() -> String {
        let dayOftheWeek = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: self) - 1]
        return dayOftheWeek
    }

    func toLongFormatString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

        return formatter.string(from: self)
    }
}
