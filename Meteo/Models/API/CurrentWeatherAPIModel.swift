//
//  CurrentWeatherAPI.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import Foundation

struct ICurrentWeatherAPIModel: Codable {
    var coord: ICoordinate?
    var weather: [IWeather]?
    var base: String?
    var main: IMainWeather?
    var visibility: Float?
    var wind: IWind?
    var rain: IRain?
    var clouds: IClouds?
    var dateTime: Float?
    var sys: ISys?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
}
