//
//  MainWeatherViewController.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import UIKit
import MapKit

class MainWeatherViewController: UIViewController {

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
    var locManager = CLLocationManager()
    var currentLocation: CLLocation? {
        didSet {
            getForecastWeather()
            getCurrentWeather()
        }
    }
    
    
    var weatherAPIClient: WeatherAPIClient = WeatherAPIClient(networkingService: MainNetworkingService())
    var forecastWeather: IForecastAPIModel?
    var curWeather: ICurrentWeatherAPIModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func getForecastWeather() {
        guard let currentLocation = self.currentLocation else {
            return
        }
        let coord = ICoordinate(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
        weatherAPIClient.fetchForecastWeatherData(coordinate: coord) { result in
            switch result {
            case .success(let forecastWeather):
                self.forecastWeather = forecastWeather
                break
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                break
            }
            
        }
    }
    
    func getCurrentWeather() {
        guard let currentLocation = self.currentLocation else {
            return
        }
        let coord = ICoordinate(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
        weatherAPIClient.fetchCurrentWeatherData(coordinate: coord) { result in
            switch result {
            case .success(let curWeather):
                self.curWeather = curWeather
                break
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                break
            }
            
        }
    }

}

extension MainWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableviewCell.identifier) as! ForecastTableviewCell
        
        return cell
        
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
