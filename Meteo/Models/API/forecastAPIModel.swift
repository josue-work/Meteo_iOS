//
//  forecastAPI.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import Foundation

struct IForecastAPIModel: Codable {
    var cod: String?
    var message: Int?
    var cnt: Int?
    var city: ICity?
    var list: [IListWeather]?
}
