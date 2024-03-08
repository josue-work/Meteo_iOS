//
//  Array+Extension.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/04.
//

import Foundation

extension Array where Element == UInt8 {
    var deobfuscated: [UInt8] {
        let first = prefix(count / 2)
        let second = suffix(count / 2)
        return zip(first, second).map(^)
    }
}
