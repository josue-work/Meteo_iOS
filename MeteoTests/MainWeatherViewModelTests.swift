//
//  MainWeatherViewModelTests.swift
//  MeteoTests
//
//  Created by Josue Muhiri Cizungu on 2024/03/04.
//

import XCTest
@testable import Meteo

class MainWeatherViewModelTests: BaseTestClass {

    var apiClient: WeatherAPIClient!
    var mainViewModel: MainViewModel!

    override func tearDown() {
        apiClient = nil
        mainViewModel = nil
        super.tearDown()
    }

    func testgetForecastWeather() {
        let mockNetworkingService = MockNetworkingService(jsonString: forecastDataString)
        apiClient = WeatherAPIClient(networkingService: mockNetworkingService)
        mainViewModel = MainViewModel()
        mainViewModel.weatherAPIClient = apiClient

        let coord = ICoordinate(lat: 0.0, lon: 0.0)
        XCTAssertNil(mainViewModel.forecastWeather)
        mainViewModel.getForecastWeather(coord: coord)
        XCTAssertNotNil(mainViewModel.forecastWeather)
        XCTAssertEqual(mainViewModel.forecastWeather?.city?.id, 3163858)
        XCTAssertEqual(mainViewModel.forecastWeather?.city?.population, 4593)
        XCTAssertEqual(mainViewModel.forecastWeather?.city?.name, "Zocca")
    }

    func testgetCurrentWeather() {
        let mockNetworkingService = MockNetworkingService(jsonString: currentWeatherDataString)
        apiClient = WeatherAPIClient(networkingService: mockNetworkingService)
        mainViewModel = MainViewModel()
        mainViewModel.weatherAPIClient = apiClient

        let coord = ICoordinate(lat: 0.0, lon: 0.0)
        XCTAssertNil(mainViewModel.currentWeather)
        mainViewModel.getCurrentWeather(coord: coord)
        XCTAssertNotNil(mainViewModel.currentWeather)
        XCTAssertEqual(mainViewModel.currentWeather?.id, 3163858)
        XCTAssertEqual(mainViewModel.currentWeather?.name, "Zocca")
    }
}
