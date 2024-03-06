//
//  Defaults.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/04.
//

import Foundation

struct Defaults {
    private static let userDefault = UserDefaults.standard
    
    static let kForecastJSON = "forecastJSONKey"
    static let kCurrentWeatherJSON = "currentWeatherJSONKey"
    
    static func getForecastWeatherJSON() -> String? {
        return userDefault.string(forKey: kForecastJSON)
    }
    
    static func getCurrentWeatherJSON() -> String? {
        return userDefault.string(forKey: kCurrentWeatherJSON)
    }
    
    static func setForecastWeatherJSON(_ jsonString: String) {
        userDefault.setValue(jsonString, forKey: kForecastJSON)
    }
    
    static func setCurrentWeatherJSON(_ jsonString: String) {
        userDefault.setValue(jsonString, forKey: kCurrentWeatherJSON)
    }
    
    static func removeAll() {
        userDefault.removeObject(forKey: kCurrentWeatherJSON)
        userDefault.removeObject(forKey: kForecastJSON)
    }
}
