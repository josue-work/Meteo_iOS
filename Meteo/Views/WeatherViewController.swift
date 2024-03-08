//
//  WeatherViewController.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import UIKit
import MapKit

enum WeatherTheme: Int {
    case forest = 0
    case sea
}

class WeatherViewController: UIViewController {

    static let identifier = "mainWeatherVC"

    @IBOutlet weak var forecastContainerView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView! {
        didSet {
            backgroundImage?.accessibilityIdentifier = Constants.AccessibilityIdentifier.mainWeatherImageView
        }
    }
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var mainSubtitleLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView! {
        didSet {
            forecastTableView.register(UINib(nibName: "ForecastTableviewCell", bundle: nil),
                                       forCellReuseIdentifier: ForecastTableviewCell.identifier)
            forecastTableView.rowHeight = UITableView.automaticDimension
            forecastTableView.estimatedRowHeight = 50
            forecastTableView.scrollsToTop = true
            forecastTableView.dataSource = self
            forecastTableView.delegate = self
        }
    }

    private var list: [IListWeather] = []
    var currentWeather: ICurrentWeatherAPIModel? {
        didSet {
            fillCurrentWeatherUI()
        }
    }
    var theme: WeatherTheme = .forest {
        didSet {
            fillCurrentWeatherUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.tag = Constants.ViewTags.tWeatherVCMainImageView
        forecastTableView.tag = Constants.ViewTags.tWeatherVCForecastImageView
        if let uiTest = (UIApplication.shared.delegate as? AppDelegate)?.uiTest,
           uiTest == true {
            list = [IListWeather(dateTime: 1661871600,
                                 main: IMainWeather(temp: 29.4,
                                                    feelsLike: 27.3,
                                                    tempMin: 19.3,
                                                    tempMax: 31.4,
                                                    pressure: 1015,
                                                    humidity: 67,
                                                    seaLevel: 1015,
                                                    groundLevel: 950,
                                                    tempKF: 54),
                                 weather: [IWeather(id: 300, main: "Rain", description: "Light rain", icon: "10d")],
                                 clouds: IClouds(all: 100),
                                 wind: IWind(speed: 0.7, deg: 320, gust: 3.5),
                                 rain: IRain(threeH: 0.3),
                                 visibility: 1000,
                                 probabilityOfPrecipitation: 0.32)]
            forecastTableView.reloadData()
        }
    }

    private func fillCurrentWeatherUI() {
        guard let currentWeather = currentWeather,
              let feelsLike = currentWeather.main?.feelsLike,
              let temp = currentWeather.main?.temp,
              let tempMax = currentWeather.main?.tempMax,
              let tempMin = currentWeather.main?.tempMin,
              let subtitle = currentWeather.weather?.first?.main else {
            if theme == .forest {
                self.backgroundImage?.image = UIImage(named: "forestSunny")
                self.forecastContainerView?.backgroundColor = UIColor(named: "forestSunny")
            } else {
                self.backgroundImage?.image = UIImage(named: "seaSunny")
                self.forecastContainerView?.backgroundColor = UIColor(named: "seaSunny")
            }
            return
        }

        DispatchQueue.main.async {

            self.mainTempLabel?.text = String(format: "%.0f°", feelsLike)
            self.mainSubtitleLabel?.text = subtitle
            self.currentTempLabel?.text = String(format: "%.0f°", temp)
            self.maxTempLabel?.text = String(format: "%.0f°", tempMax)
            self.minTempLabel?.text = String(format: "%.0f°", tempMin)

            if let weatherString = WeatherString(rawValue: subtitle) {
                if self.theme == .forest {
                    switch weatherString {
                    case .cloudy:
                        self.backgroundImage?.image = UIImage(named: "forestCloudy")
                        self.forecastContainerView?.backgroundColor = UIColor(named: "cloudy")
                    case .rainy, .drizzle, .snow, .thunderStorm:
                        self.backgroundImage?.image = UIImage(named: "forestRainy")
                        self.forecastContainerView?.backgroundColor = UIColor(named: "rainy")
                    case .sunny:
                        self.backgroundImage?.image = UIImage(named: "forestSunny")
                        self.forecastContainerView?.backgroundColor = UIColor(named: "forestSunny")
                    }
                } else {
                    switch weatherString {
                    case .cloudy:
                        self.backgroundImage?.image = UIImage(named: "seaCloudy")
                        self.forecastContainerView?.backgroundColor = UIColor(named: "cloudy")
                    case .rainy, .drizzle, .snow, .thunderStorm:
                        self.backgroundImage?.image = UIImage(named: "seaRainy")
                        self.forecastContainerView?.backgroundColor = UIColor(named: "rainy")
                    case .sunny:
                        self.backgroundImage?.image = UIImage(named: "seaSunny")
                        self.forecastContainerView?.backgroundColor = UIColor(named: "seaSunny")
                    }
                }
            }
        }
    }

    func fillForecastWeatherUI(_ forecastWeather: IForecastAPIModel) {
        DispatchQueue.main.async {
            if let uiTest = (UIApplication.shared.delegate as? AppDelegate)?.uiTest,
               uiTest == true {
                return
            }
            self.reduceForecastToDailySample(forecastWeather)
            self.forecastTableView?.reloadData()
        }
    }

    private func reduceForecastToDailySample(_ forecastWeather: IForecastAPIModel) {
        guard let forecastList = forecastWeather.list else {
            return
        }
        var sortedForecastList = forecastList
        sortedForecastList.sort {
            guard let firstItemDT = $0.dateTime, let secondItemDT = $1.dateTime else {
                return false
            }
            return firstItemDT < secondItemDT
        }
        list = []
        for item in sortedForecastList {
            if list.isEmpty {
                list.append(item)
            } else {
                if let nextDayDateTime = list.last?.dateTime,
                   let dateTime = item.dateTime {
                    let nDay = nextDayDateTime + 86400
                    if nDay <= dateTime {
                        list.append(item)
                    }
                }
            }
        }
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = list[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableviewCell.identifier)
                as? ForecastTableviewCell else {
            fatalError("ForecastTableViewCell xib not registered")
        }
        if let uiTest = (UIApplication.shared.delegate as? AppDelegate)?.uiTest,
           uiTest == true,
            indexPath.row == 0 {
            cell.accessibilityIdentifier = "forecastCellID"
        }
        cell.fillUIWith(item)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mapModalVC = UIStoryboard(name: "Main",
                                            bundle: Bundle.main)
                    .instantiateViewController(withIdentifier: DetailsWeatherViewController.navControllerIdentifier)
                as? UINavigationController else {
            fatalError("MapViewController navigation controller does not exist")
        }
        (mapModalVC.viewControllers.first as? DetailsWeatherViewController)?.data = list[indexPath.row]
        present(mapModalVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
