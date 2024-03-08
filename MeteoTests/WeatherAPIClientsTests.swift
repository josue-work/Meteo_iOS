//
//  WeatherAPIClientsTests.swift
//  MeteoTests
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import XCTest
@testable import Meteo

class WeatherAPIClientsTests: BaseTestClass {

    var apiClient: WeatherAPIClient!

    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }

    func testfetchCurrentWeatherData() {
        let mockNetworkingService = MockNetworkingService(jsonString: currentWeatherDataString)
        apiClient = WeatherAPIClient(networkingService: mockNetworkingService)

        let expectation = self.expectation(description: "Fetch current weather data")
        let coord = ICoordinate(lat: 0.0, lon: 0.0)
        apiClient.fetchCurrentWeatherData(coordinate: coord) { result in
            switch result {
            case .success(let curWeather):
                XCTAssertEqual(curWeather.id, 3163858)
                XCTAssertEqual(curWeather.name, "Zocca")
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testfetchForecastWeatherData() {
        let mockNetworkingService = MockNetworkingService(jsonString: forecastDataString)
        apiClient = WeatherAPIClient(networkingService: mockNetworkingService)

        let expectation = self.expectation(description: "Fetch forecast weather data")
        let coord = ICoordinate(lat: 0.0, lon: 0.0)
        apiClient.fetchForecastWeatherData(coordinate: coord) { result in
            switch result {
            case .success(let forecast):
                XCTAssertEqual(forecast.city?.id, 3163858)
                XCTAssertEqual(forecast.city?.population, 4593)
                XCTAssertEqual(forecast.city?.name, "Zocca")
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
