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
    var feelsLike: Float?
    var tempMin: Float?
    var tempMax: Float?
    var pressure: Int?
    var humidity: Int?
    var seaLevel: Int?
    var groundLevel: Int?
    var tempKF: Float?
    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like",
             tempMin = "temp_min",
             tempMax = "temp_max",
             seaLevel = "sea_level",
             groundLevel = "grnd_level",
             tempKF = "temp_kf",
             temp,
             pressure,
             humidity
    }
}

struct IWind: Codable {
    var speed: Float?
    var deg: Int?
    var gust: Float?
}

struct IRain: Codable {
    var oneH: Float?
    var threeH: Float?
    enum CodingKeys: String, CodingKey {
        case oneH = "1h",
             threeH = "3h"
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
    var dateTime: Int?
    var main: IMainWeather?
    var weather: [IWeather]?
    var clouds: IClouds?
    var wind: IWind?
    var rain: IRain?
    var visibility: Int?
    var probabilityOfPrecipitation: Float?
    var sys: ISys?
    var dateTimeString: String?
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt",
        main,
        weather,
        clouds,
        wind,
        rain,
        visibility,
        probabilityOfPrecipitation = "pop",
        sys,
        dateTimeString = "dt_txt"
    }
}

enum WeatherString: String {
    case rainy = "Rain"
    case cloudy = "Clouds"
    case sunny = "Clear"
    case drizzle = "Drizzle"
    case snow = "Snow"
    case thunderStorm = "Thunderstorm"
}
