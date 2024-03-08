//
//  BaseXCTestCase.swift
//  MeteoTests
//
//  Created by Josue Muhiri Cizungu on 2024/03/07.
//

import XCTest

class BaseTestClass: XCTestCase {
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
                "feelsLike": 298.74,
                "tempMin": 297.56,
                "tempMax": 300.05,
                "pressure": 1015,
                "humidity": 64,
                "seaLevel": 1015,
                "groundLevel": 933
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
            "feelsLike": 296.98,
            "tempMin": 296.76,
            "tempMax": 297.87,
            "pressure": 1015,
            "seaLevel": 1015,
            "groundLevel": 933,
            "humidity": 69,
            "tempKF": -1.11
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
}
