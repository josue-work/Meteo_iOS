//
//  MainWeatherViewModel.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/04.
//

import Foundation

protocol MainViewModelDelegate: NSObjectProtocol {
    func forecastUpdated()
    func currentWeatherUpdated()
}

class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    var weatherAPIClient: WeatherAPIClient = WeatherAPIClient(networkingService: MainNetworkingService())
    var forecastWeather: IForecastAPIModel?
    var currentWeather: ICurrentWeatherAPIModel?

    func getForecastWeather(coord: ICoordinate) {
        weatherAPIClient.fetchForecastWeatherData(coordinate: coord) { result in
            switch result {
            case .success(let forecastWeather):
                self.forecastWeather = forecastWeather
                self.delegate?.forecastUpdated()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func getCurrentWeather(coord: ICoordinate) {
        weatherAPIClient.fetchCurrentWeatherData(coordinate: coord) { result in
            switch result {
            case .success(let curWeather):
                self.currentWeather = curWeather
                self.delegate?.currentWeatherUpdated()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func getSavedString() {
        if let currentWeather = Defaults.getCurrentWeatherJSON(),
           let data = currentWeather.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                self.currentWeather = try decoder.decode(ICurrentWeatherAPIModel.self, from: data)
                self.delegate?.currentWeatherUpdated()
            } catch {
                print("Unable to parse saved CurrentWeather data")
            }
        }

        if let forecastWeather = Defaults.getForecastWeatherJSON(),
           let data = forecastWeather.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                self.forecastWeather = try decoder.decode(IForecastAPIModel.self, from: data)
                self.delegate?.forecastUpdated()
            } catch {
                print("Unable to parse saved Forecast weather data")
            }
        }
    }
}
