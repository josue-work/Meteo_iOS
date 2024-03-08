//
//  Constants.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/04.
//

import Foundation

class Constants {
    static let ObfuscatedOpenWeatherAPIKey: [UInt8] = [96, 16, 214, 62, 83, 76,
                                                       244, 33, 207, 180, 154,
                                                       231, 207, 80, 97, 158,
                                                       57, 188, 217, 53, 252,
                                                       124, 163, 151, 121, 186,
                                                       58, 175, 134, 234, 191,
                                                       163, 4, 34, 239, 91,
                                                       97, 46, 150, 16, 170,
                                                       128, 169, 212, 252, 98,
                                                       4, 253, 1, 222, 235,
                                                       80, 152, 25, 199, 164,
                                                       28, 143, 10, 205, 183,
                                                       217, 142, 151]

    static let obfuscatedTestString: [UInt8] = [251, 128, 42, 211, 172,
                                         140, 46, 26, 169, 221,
                                         219, 32, 83, 212, 45,
                                         60, 125, 113, 77, 175,
                                         131, 205, 241, 34, 21,
                                         107, 224, 1, 75, 108,
                                         10, 227, 237, 175, 186,
                                         221, 29, 237, 68, 149,
                                         14, 201, 20, 66, 45,
                                         54, 97, 105, 226, 198,
                                         93, 24, 217, 184, 175,
                                         232, 67, 160, 140, 229,
                                         93, 58, 221, 178, 251,
                                         84, 54, 167, 89, 28,
                                         16, 8, 109, 192, 225,
                                         171, 132, 81, 118, 10,
                                         148, 100, 47, 76, 121,
                                         151, 159, 198, 212, 186,
                                         61, 132, 55, 181, 106,
                                         172, 119, 45, 73, 83,
                                         5, 73, 140, 175, 62,
                                         125, 181, 193]

    static var openWeatherAPIKey: String {
        return String(bytes: ObfuscatedOpenWeatherAPIKey.deobfuscated,
            encoding: .utf8)!
    }

    static var testStringKey: String {
        return String(bytes: obfuscatedTestString.deobfuscated,
            encoding: .utf8)!
    }

    struct ViewTags {
        static let tMainVCCurrentView = 99
        static let tCityInputTextfield = 101
        static let tLatitudeInputTextfield = 102
        static let tLongitudeInputTextfield = 103
        static let tSideMenuVC = 21
        static let tMapVC = 31
        static let tSideMenuOptionTableView = 41
        static let tSideMenuFavoritesTableView = 51
        static let tWeatherVCMainImageView = 61
        static let tWeatherVCForecastImageView = 71
    }

    struct AccessibilityIdentifier {
        static let mainWeatherImageView = "mainWeatherImageView"
    }
}
