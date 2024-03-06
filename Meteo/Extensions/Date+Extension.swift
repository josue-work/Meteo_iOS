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
}
