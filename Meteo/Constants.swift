//
//  Constants.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/04.
//

import Foundation

class Constants {
    static let ObfuscatedOpenWeatherAPIKey: [UInt8] = [96, 16, 214, 62, 83, 76, 244, 33, 207, 180, 154, 231, 207, 80, 97, 158, 57, 188, 217, 53, 252, 124, 163, 151, 121, 186, 58, 175, 134, 234, 191, 163, 4, 34, 239, 91, 97, 46, 150, 16, 170, 128, 169, 212, 252, 98, 4, 253, 1, 222, 235, 80, 152, 25, 199, 164, 28, 143, 10, 205, 183, 217, 142, 151]
    
    static var openWeatherAPIKey: String {
        return String(bytes: ObfuscatedOpenWeatherAPIKey.deobfuscated,
            encoding: .utf8)!
    }
    
    
}
