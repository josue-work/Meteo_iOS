//
//  WeatherAPIClient.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import Foundation

class WeatherAPIClient {
    private let networkingService: NetworkingService

    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    func fetchCurrentWeatherData(coordinate: ICoordinate, completion: @escaping (Result<ICurrentWeatherAPIModel, Error>) -> Void) {
        guard let lat = coordinate.lat, let lon = coordinate.lon else {
            return
        }
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.openWeatherAPIKey)") else {
            return
        }
        networkingService.fetchData(url: url) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let decoder = JSONDecoder()
            do {
                let curWeather = try decoder.decode(ICurrentWeatherAPIModel.self, from: data!)
                completion(.success(curWeather))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchForecastWeatherData(coordinate: ICoordinate, completion: @escaping (Result<IForecastAPIModel, Error>) -> Void) {
        guard let lat = coordinate.lat, let lon = coordinate.lon else {
            return
        }
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(Constants.openWeatherAPIKey)") else {
            return
        }
        networkingService.fetchData(url: url) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let decoder = JSONDecoder()
            do {
                let forecastWeather = try decoder.decode(IForecastAPIModel.self, from: data!)
                completion(.success(forecastWeather))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
