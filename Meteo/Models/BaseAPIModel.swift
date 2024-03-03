//
//  BaseAPI.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import Foundation

struct ICoordinate: Codable {
    var lat: Double?
    var lon: Double?
}

struct IWeather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct IMainWeather: Codable {
    var temp: Float?
    var feels_like: Float?
    var temp_min: Float?
    var temp_max: Float?
    var pressure: Int?
    var humidity: Int?
    var sea_level: Int?
    var grnd_level: Int?
}

struct IWind: Codable {
    var speed: Float?
    var deg: Int?
    var gust: Float?
}

struct IRain: Codable {
    var one_h: Float?
    var three_h: Float?
    
    enum CodingKeys: String, CodingKey {
        case one_h = "1h",
                three_h = "3h"
    }
}

struct IClouds: Codable {
    var all: Int?
}

struct ISys: Codable {
    var type: Int?
    var id: Int?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
    var pod: String?
}

struct ICity: Codable {
    var id: Int?
    var name: String?
    var coord: ICoordinate?
    var country: String?
    var population: Int?
    var timezone: Int?
    var sunrise: Int?
    var sunset: Int?
}

struct IListWeather: Codable {
    var dt: Int?
    var main: IMainWeather?
    var weather: [IWeather]?
    var clouds: IClouds?
    var wind: IWind?
    var rain: IRain?
    var visibility: Int?
    var pop: Float?
    var sys: ISys?
    var dt_txt: String?
}
