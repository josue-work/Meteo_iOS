//
//  MainViewController.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/06.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuShadowView: UIView!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    private weak var weatherViewController: WeatherViewController?
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var revealSideMenuOnTop: Bool = true
    private var viewModel: MainViewModel = MainViewModel()
    private var locManager = CLLocationManager()
    private var currentLocation: CLLocation? {
        didSet {
            getWeatherForLocation()
        }
    }
    private var gestureEnabled: Bool = true
    private var selectedFavorite: FavoritesModel? {
        didSet {
            guard let selectedFavorites = selectedFavorite else {
                return
            }
            viewModel.getForecastWeather(coord: selectedFavorites.coordinate)
            viewModel.getCurrentWeather(coord: selectedFavorites.coordinate)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarAppearance(tintColor: .label, barColor: .systemCyan)

        viewModel.delegate = self
        setupLocation()
        setupShadowBackgroundView()
        setupSideMenu()

        showMainWeatherView()

        // get saved data
        if let themeRawValue = Defaults.getTheme(),
           let theme = WeatherTheme(rawValue: themeRawValue) {
            sideMenuViewController.themeSelectorSegmentedControl.selectedSegmentIndex = themeRawValue
            weatherViewController?.theme = theme
        }
        viewModel.getSavedString()
    }

    // Keep the state of the side menu (expanded or collapse) in rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = self.isExpanded ?
                0 : -(self.sideMenuRevealWidth + self.paddingForRotation)
            }
        }
    }

    private func setupSideMenu() {
        sideMenuViewController = UIStoryboard(name: "Main",
                                              bundle: Bundle.main)
        .instantiateViewController(withIdentifier: "SideMenuVC")
        as? SideMenuViewController
        sideMenuViewController.delegate = self
        if let favoritesJSON = Defaults.getFavoritesJSON(),
           let data = favoritesJSON.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                sideMenuViewController.favorites = try decoder.decode([FavoritesModel].self, from: data)
            } catch {
                print("Unable to parse saved favorites data")
            }
        }
        
        view.insertSubview(sideMenuViewController!.view, at: revealSideMenuOnTop ? 2 : 0)
        addChild(sideMenuViewController!)
        sideMenuViewController.didMove(toParent: self)

        sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false

        if revealSideMenuOnTop {
            sideMenuTrailingConstraint = sideMenuViewController
                .view.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: -(sideMenuRevealWidth + paddingForRotation))
            sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            sideMenuViewController.view.widthAnchor.constraint(equalToConstant: sideMenuRevealWidth),
            sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        // Side Menu Gestures
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }

    private func setupLocation() {
        switch locManager.authorizationStatus {
        case .restricted, .denied:
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Location permission denied",
                                              message: "Please go to settings -> Meteo \nAnd allow the meteo app access to your location.",
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        case .notDetermined:
            locManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocation = locManager.location
        default:
            break
        }
    }

    private func setupShadowBackgroundView() {
        sideMenuShadowView = UIView(frame: view.bounds)
        sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideMenuShadowView.backgroundColor = .black
        sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        sideMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        if revealSideMenuOnTop {
            view.insertSubview(sideMenuShadowView, at: 1)
        }
    }

    private func sideMenuState(expanded: Bool) {
        if expanded {
            animateSideMenu(targetPosition: revealSideMenuOnTop ? 0 : sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) {
                self.sideMenuShadowView.alpha = 0.6
            }
        } else {
            animateSideMenu(targetPosition: revealSideMenuOnTop ?
                            -(sideMenuRevealWidth + paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) {
                self.sideMenuShadowView.alpha = 0.0
            }
        }
    }

    private func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            } else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }

    private func getWeatherForLocation() {
        guard let currentLocation = self.currentLocation,
              selectedFavorite == nil else {
            return
        }
        let coord = ICoordinate(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
        viewModel.getForecastWeather(coord: coord)
        viewModel.getCurrentWeather(coord: coord)
    }
}

extension MainViewController: SideMenuViewControllerDelegate {
    func saveFavorites() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(self.sideMenuViewController.favorites) {
            let jsonString = String(decoding: encodedData, as: UTF8.self)
            Defaults.setFavoritesJSON(jsonString)
        }
    }
    
    func addFavorite() {
        currentLocation?.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            DispatchQueue.main.async {
                self.sideMenuState(expanded: false)
                var cityTextfield: UITextField?
                let alert = UIAlertController(title: "Add Favorite",
                                              message: "current City/Lat/Long",
                                              preferredStyle: UIAlertController.Style.alert)
                let saveAction = UIAlertAction(title: "Save",
                                               style: UIAlertAction.Style.default,
                                               handler: { _ in
                     guard let city = cityTextfield?.text,
                           let lat = self.currentLocation?.coordinate.latitude,
                           let lon = self.currentLocation?.coordinate.longitude,
                           let uiTest = (UIApplication.shared.delegate as? AppDelegate)?.uiTest,
                           uiTest != true  else {
                         return
                     }
                     let newFavorite = FavoritesModel(coordinate: ICoordinate(lat: lat, lon: lon),
                                                      cityName: city)
                     self.sideMenuViewController.favorites.append(newFavorite)
                    self.saveFavorites()
                     self.sideMenuViewController.favoritesTableView.reloadData()
                 })
                saveAction.accessibilityIdentifier = "favoriteSaveAction"
                alert.addAction(saveAction)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addTextField(configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = "City"
                    textField.text = placemark.neighborhood
                    textField.tag = 101
                    cityTextfield = textField
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func selectedFavorites(_ data: FavoritesModel) {
        selectedFavorite = data
    }

    func setTheme(_ theme: WeatherTheme) {
        Defaults.setTheme(theme.rawValue)
        weatherViewController?.theme = theme
    }

    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            selectedFavorite = nil
            getWeatherForLocation()
            showMainWeatherView()
        case 1:
            guard let mapModalVC = UIStoryboard(name: "Main",
                                                bundle: Bundle.main)
                .instantiateViewController(withIdentifier: MapViewController.navControllerIdentifier)
                    as? UINavigationController else {
                fatalError("MapViewController navigation controller does not exist")
            }
            (mapModalVC.viewControllers.first as? MapViewController)?.favorites = sideMenuViewController.favorites
            (mapModalVC.viewControllers.first as? MapViewController)?.delegate = self
            present(mapModalVC, animated: true, completion: nil)
        default:
            break
        }

        // Collapse side menu with animation
        DispatchQueue.main.async {
            self.sideMenuState(expanded: false)
        }
    }

    func showMainWeatherView() {
        for subview in view.subviews where subview.tag == 99 {
            weatherViewController = nil
            subview.removeFromSuperview()
        }
        guard let viewController = UIStoryboard(name: "Main",
                                                bundle: nil)
            .instantiateViewController(withIdentifier: WeatherViewController.identifier)
                as? WeatherViewController else {
            fatalError("Could not find class in storyboard")
        }
        viewController.view.tag = 99
        view.insertSubview(viewController.view, at: revealSideMenuOnTop ? 0 : 1)
        addChild(viewController)
        DispatchQueue.main.async {
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                viewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                viewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                viewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                viewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
            self.weatherViewController = viewController
            self.currentWeatherUpdated()
            self.forecastUpdated()
            if let theme = WeatherTheme(rawValue:
                                            self.sideMenuViewController
                .themeSelectorSegmentedControl.selectedSegmentIndex) {
                self.weatherViewController?.theme = theme
            }
        }
        if !revealSideMenuOnTop {
            if isExpanded {
                viewController.view.frame.origin.x = sideMenuRevealWidth
            }
            if sideMenuShadowView != nil {
                viewController.view.addSubview(sideMenuShadowView)
            }
        }
        viewController.didMove(toParent: self)
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    @objc func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if isExpanded {
                sideMenuState(expanded: false)
            }
        }
    }

    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: sideMenuViewController.view))! {
            return false
        }
        return true
    }

    // Dragging Side Menu
    @objc
    private func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard gestureEnabled == true else { return }
        let position: CGFloat = sender.translation(in: view).x
        let velocity: CGFloat = sender.velocity(in: view).x
        switch sender.state {
        case .began:
            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
            if velocity > 0, isExpanded {
                sender.state = .cancelled
            }
            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
            if velocity > 0, !isExpanded {
                draggingIsEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging
            else if velocity < 0, isExpanded {
                draggingIsEnabled = true
            }
            if draggingIsEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    sideMenuState(expanded: isExpanded ? false : true)
                    draggingIsEnabled = false
                    return
                }
                if revealSideMenuOnTop {
                    panBaseLocation = 0.0
                    if isExpanded {
                        panBaseLocation = sideMenuRevealWidth
                    }
                }
            }
        case .changed:
            // Expand/Collapse side menu while dragging
            if draggingIsEnabled {
                if revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = panBaseLocation + position
                    let percentage = (xLocation * 150 / sideMenuRevealWidth) / sideMenuRevealWidth

                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    sideMenuShadowView.alpha = alpha

                    // Move side menu while dragging
                    if xLocation <= sideMenuRevealWidth {
                        sideMenuTrailingConstraint.constant = xLocation - sideMenuRevealWidth
                    }
                } else {
                    if let recogView = sender.view?.subviews[1] {
                        // Show/Hide shadow background view while dragging
                        let percentage = (recogView.frame.origin.x * 150 / sideMenuRevealWidth) / sideMenuRevealWidth

                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        sideMenuShadowView.alpha = alpha

                        // Move side menu while dragging
                        if recogView.frame.origin.x <= sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x += position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            draggingIsEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animation
            if revealSideMenuOnTop {
                let movedMoreThanHalf = sideMenuTrailingConstraint.constant > -(sideMenuRevealWidth * 0.5)
                sideMenuState(expanded: movedMoreThanHalf)
            } else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > sideMenuRevealWidth * 0.5
                    sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        setupLocation()
    }
}

extension MainViewController: MainViewModelDelegate {
    func forecastUpdated() {
        guard let forecastWeather = viewModel.forecastWeather else {
            return
        }
        weatherViewController?.fillForecastWeatherUI(forecastWeather)
    }

    func currentWeatherUpdated() {
        weatherViewController?.currentWeather = viewModel.currentWeather
        if let selectedFavorite = selectedFavorite {
            DispatchQueue.main.async {
                self.sideMenuViewController.mainTitleLabel.text = "Meteo - \(selectedFavorite.cityName)"
            }
        } else {
            currentLocation?.placemark { placemark, error in
                guard let placemark = placemark else {
                    print("Error:", error ?? "nil")
                    return
                }
                DispatchQueue.main.async {
                    self.sideMenuViewController?.mainTitleLabel?.text = "Meteo - \(placemark.neighborhood ?? "N/A")"
                }
            }
        }
    }
}

extension MainViewController: MapViewDelegate {
    func addNewFavorite(_ favorite: FavoritesModel) {
        self.sideMenuViewController.favorites.append(favorite)
        self.sideMenuViewController.favoritesTableView.reloadData()
    }
}
