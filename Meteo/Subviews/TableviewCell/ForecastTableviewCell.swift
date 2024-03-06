//
//  ForecastTableviewCell.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import UIKit

class ForecastTableviewCell: UITableViewCell {
    
    static let identifier = "forecastCell"
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func fillUIWith(_ data: IListWeather) {
        guard let dt = data.dt,
              let temp = data.main?.temp,
              let subtitle = data.weather?.first?.main else {
            return
        }
        let date = Date(timeIntervalSince1970: Double(dt))
        let dayOfTheWeek = date.dayOfTheWeek()
        DispatchQueue.main.async {
            
            self.dayLabel.text = dayOfTheWeek.capitalized
            self.temperatureLabel.text = String(format: "%.0f°", temp)
            if let weatherString = WeatherString(rawValue: subtitle) {
                switch weatherString {
                case .cloudy:
                    self.iconView.image = UIImage(named: "partlySunny")
                    break
                case .rainy, .drizzle, .snow, .thunderStorm:
                    self.iconView.image = UIImage(named: "rain")
                    break
                case .sunny:
                    self.iconView.image = UIImage(named: "clear")
                    break
                }
            }
        }
    }
}
