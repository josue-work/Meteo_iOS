//
//  MainWeatherViewModelTests.swift
//  MeteoTests
//
//  Created by Josue Muhiri Cizungu on 2024/03/04.
//

import XCTest
@testable import Meteo

class MainWeatherViewModelTests: XCTestCase {
    
    var apiClient: WeatherAPIClient!
    var mainViewModel: MainWeatherViewModel!
    let currentWeatherDataString =
        """
            {
              "coord": {
                "lon": 10.99,
                "lat": 44.34
              },
              "weather": [
                {
                  "id": 501,
                  "main": "Rain",
                  "description": "moderate rain",
                  "icon": "10d"
                }
              ],
              "base": "stations",
              "main": {
                "temp": 298.48,
                "feels_like": 298.74,
                "temp_min": 297.56,
                "temp_max": 300.05,
                "pressure": 1015,
                "humidity": 64,
                "sea_level": 1015,
                "grnd_level": 933
              },
              "visibility": 10000,
              "wind": {
                "speed": 0.62,
                "deg": 349,
                "gust": 1.18
              },
              "rain": {
                "1h": 3.16
              },
              "clouds": {
                "all": 100
              },
              "dt": 1661870592,
              "sys": {
                "type": 2,
                "id": 2075663,
                "country": "IT",
                "sunrise": 1661834187,
                "sunset": 1661882248
              },
              "timezone": 7200,
              "id": 3163858,
              "name": "Zocca",
              "cod": 200
            }
        """
    
    let forecastDataString =
    """
    {
      "cod": "200",
      "message": 0,
      "cnt": 40,
      "list": [
        {
          "dt": 1661871600,
          "main": {
            "temp": 296.76,
            "feels_like": 296.98,
            "temp_min": 296.76,
            "temp_max": 297.87,
            "pressure": 1015,
            "sea_level": 1015,
            "grnd_level": 933,
            "humidity": 69,
            "temp_kf": -1.11
          },
          "weather": [
            {
              "id": 500,
              "main": "Rain",
              "description": "light rain",
              "icon": "10d"
            }
          ],
          "clouds": {
            "all": 100
          },
          "wind": {
            "speed": 0.62,
            "deg": 349,
            "gust": 1.18
          },
          "visibility": 10000,
          "pop": 0.32,
          "rain": {
            "3h": 0.26
          },
          "sys": {
            "pod": "d"
          },
          "dt_txt": "2022-08-30 15:00:00"
        }
      ],
      "city": {
        "id": 3163858,
        "name": "Zocca",
        "coord": {
          "lat": 44.34,
          "lon": 10.99
        },
        "country": "IT",
        "population": 4593,
        "timezone": 7200,
        "sunrise": 1661834187,
        "sunset": 1661882248
      }
    }
    """
    
    override func tearDown() {
        apiClient = nil
        mainViewModel = nil
        super.tearDown()
    }
    
    func testgetForecastWeather() {
        let mockNetworkingService = MockNetworkingService(jsonString: forecastDataString)
        apiClient = WeatherAPIClient(networkingService: mockNetworkingService)
        mainViewModel = MainWeatherViewModel()
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
        mainViewModel = MainWeatherViewModel()
        mainViewModel.weatherAPIClient = apiClient
        
        let coord = ICoordinate(lat: 0.0, lon: 0.0)
        XCTAssertNil(mainViewModel.curWeather)
        mainViewModel.getCurrentWeather(coord: coord)
        XCTAssertNotNil(mainViewModel.curWeather)
        XCTAssertEqual(mainViewModel.curWeather?.id, 3163858)
        XCTAssertEqual(mainViewModel.curWeather?.name, "Zocca")
        
    }
}
