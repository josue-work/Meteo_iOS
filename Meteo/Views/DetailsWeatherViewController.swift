//
//  DetailsWeatherViewController.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/07.
//

import UIKit

class DetailsWeatherViewController: UIViewController {

    static let identifier = "DetailsVC"
    static let navControllerIdentifier = "DetailsNC"

    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var seaLevelLabel: UILabel!
    @IBOutlet weak var groundLevelLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherMainLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDegLabel: UILabel!
    @IBOutlet weak var windGustLabel: UILabel!
    @IBOutlet weak var rainThreeHourLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var cloudsAllLabel: UILabel!
    @IBOutlet weak var probabilityOfPrecipitationLabel: UILabel!

    var data: IListWeather?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = data else {
            return
        }
        fillUIWith(data)
    }

    private func fillUIWith(_ data: IListWeather) {
        if let dateTime = data.dateTime {
            let date = Date(timeIntervalSince1970: Double(dateTime))
            let string = date.toLongFormatString()
            dateTimeLabel.text = string
        }
        if let temp = data.main?.temp {
            temperatureLabel.text = "\(temp)°"
        }
        if let tempMin = data.main?.tempMin {
            minTemperatureLabel.text = "\(tempMin)°"
        }
        if let tempMax = data.main?.tempMax {
            maxTemperatureLabel.text = "\(tempMax)°"
        }
        if let feelsLike = data.main?.feelsLike {
            feelsLikeLabel.text = "\(feelsLike)°"
        }
        if let pressure = data.main?.pressure {
            pressureLabel.text = "\(pressure)Pa"
        }
        if let seaLevel = data.main?.seaLevel {
            seaLevelLabel.text = "\(seaLevel)MAMSL"
        }
        if let groundLevel = data.main?.groundLevel {
            groundLevelLabel.text = "\(groundLevel)MAMSL"
        }
        if let humidity = data.main?.humidity {
            humidityLabel.text = "\(humidity)g/Kg"
        }
        if let weatherMain = data.weather?.first?.main {
            weatherMainLabel.text = "\(weatherMain)"
        }
        if let weatherDescription = data.weather?.first?.description {
            weatherDescriptionLabel.text = "\(weatherDescription)"
        }
        if let speed = data.wind?.speed {
            windSpeedLabel.text = "\(speed)km/h"
        }
        if let gust = data.wind?.gust {
            windGustLabel.text = "\(gust)km/h"
        }
        if let deg = data.wind?.deg {
            windDegLabel.text = "\(deg)°"
        }
        if let rain = data.rain?.threeH {
            rainThreeHourLabel.text = "\(rain)mm"
        }
        if let visibility = data.visibility {
            visibilityLabel.text = "\(visibility)km"
        }
        if let clouds = data.clouds?.all {
            cloudsAllLabel.text = "\(clouds)"
        }
        if let probabilityOfPrecipitation = data.probabilityOfPrecipitation {
            probabilityOfPrecipitationLabel.text = "\(probabilityOfPrecipitation)%"
        }
    }
}
