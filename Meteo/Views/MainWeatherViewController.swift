//
//  MainWeatherViewController.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import UIKit
import MapKit

class MainWeatherViewController: UIViewController {

    
    @IBOutlet weak var forecastContainerView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var mainSubtitleLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView! {
        didSet {
            forecastTableView.register(UINib(nibName: "ForecastTableviewCell", bundle: nil), forCellReuseIdentifier: ForecastTableviewCell.identifier)
            forecastTableView.rowHeight = UITableView.automaticDimension
            forecastTableView.estimatedRowHeight = 52
            forecastTableView.scrollsToTop = true
            forecastTableView.allowsSelection = false
            forecastTableView.dataSource = self
            forecastTableView.delegate = self
        }
    }
    var viewModel: MainWeatherViewModel!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation? {
        didSet {
            guard let currentLocation = self.currentLocation else {
                return
            }
            let coord = ICoordinate(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
            viewModel.getForecastWeather(coord: coord)
            viewModel.getCurrentWeather(coord: coord)
        }
    }
    var list: [IListWeather] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainWeatherViewModel()
        viewModel.delegate = self
        viewModel.getSavedString()
        switch locManager.authorizationStatus {
        case .restricted, .denied:
            print("Location denied")
            break
        case .notDetermined:
            locManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocation = locManager.location
        default:
            break
        }
    }
    
    func fillCurrentWeatherUI() {
        guard let currentWeather = viewModel.curWeather,
              let feelsLike = currentWeather.main?.feels_like,
              let temp = currentWeather.main?.temp,
              let tempMax = currentWeather.main?.temp_max,
              let tempMin = currentWeather.main?.temp_min,
              let subtitle = currentWeather.weather?.first?.main else {
            return
        }
        
        DispatchQueue.main.async {
            
            self.mainTempLabel.text = String(format: "%.0f°", feelsLike)
            self.mainSubtitleLabel.text = subtitle
            self.currentTempLabel.text = String(format: "%.0f°", temp)
            self.maxTempLabel.text = String(format: "%.0f°", tempMax)
            self.minTempLabel.text = String(format: "%.0f°", tempMin)
            
            if let weatherString = WeatherString(rawValue: subtitle) {
                switch weatherString {
                case .cloudy:
                    self.backgroundImage.image = UIImage(named: "forestCloudy")
                    self.forecastContainerView.backgroundColor = UIColor(named: "cloudy")
                    break
                case .rainy, .drizzle, .snow, .thunderStorm:
                    self.backgroundImage.image = UIImage(named: "forestRainy")
                    self.forecastContainerView.backgroundColor = UIColor(named: "rainy")
                    break
                case .sunny:
                    self.backgroundImage.image = UIImage(named: "forestSunny")
                    self.forecastContainerView.backgroundColor = UIColor(named: "sunny")
                    break
                }
            }
        }
    }
    
    func fillForecastWeatherUI() {
        reduceForecastToDailySample()
        DispatchQueue.main.async {
            self.forecastTableView.reloadData()
        }
    }
    
    func reduceForecastToDailySample() {
        guard let forecastWeather = viewModel.forecastWeather,
              let forecastList = forecastWeather.list else {
            return
        }
        var sortedForecastList = forecastList
        sortedForecastList.sort {
            guard let firstItemDT = $0.dt, let secondItemDT = $1.dt else {
                return false
            }
            return firstItemDT < secondItemDT
        }
        list = []
        for item in sortedForecastList {
            if list.isEmpty {
                list.append(item)
            } else {
                if let nextDay_dt = list.last?.dt,
                   let dt = item.dt {
                    let nDay = nextDay_dt + 86400
                    if nDay <= dt {
                        list.append(item)
                    }
                }
            }
        }
        print("List has \(list.count) items")
    }

}

extension MainWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableviewCell.identifier) as! ForecastTableviewCell
        cell.fillUIWith(item)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            return nil
    }
    
    
}

extension MainWeatherViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locManager.authorizationStatus {
            case .restricted, .denied:
                print("Location denied")
                break
            case .notDetermined:
                locManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
                currentLocation = locManager.location
            default:
                break
        }
    }
    
}

extension MainWeatherViewController: MainWeatherViewModelDelegate {
    func forecastUpdated() {
        fillForecastWeatherUI()
    }
    
    func curentWeatherUpdated() {
        fillCurrentWeatherUI()
    }
    
}
