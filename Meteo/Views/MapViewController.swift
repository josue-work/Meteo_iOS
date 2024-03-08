//
//  MapViewController.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/06.
//

import UIKit
import MapKit

protocol MapViewDelegate: NSObjectProtocol {
    func addNewFavorite(_ favorite: FavoritesModel)
}

class MapViewController: UIViewController {

    static let identifier = "MapVC"
    static let navControllerIdentifier = "MapNC"

    @IBOutlet weak var mapView: MKMapView!
    var favorites: [FavoritesModel] = []
    weak var delegate: MapViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        addAnottations()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        longPress.minimumPressDuration = 2
        mapView.addGestureRecognizer(longPress)
    }

    private func addAnottations() {
        var annotationList: [MKPointAnnotation] = []
        for item in favorites {
            guard let lat = item.coordinate.lat, let lon = item.coordinate.lon else {
                continue
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            annotationList.append(annotation)
        }
        mapView.addAnnotations(annotationList)
    }

    @objc func handleLongPress(sender: UIGestureRecognizer) {
        if sender.state != .began {
            return
        }
        let touchPoint: CGPoint = sender.location(in: self.mapView)
        let touchMapCoord: CLLocationCoordinate2D = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        let annot = MKPointAnnotation()
        annot.coordinate = touchMapCoord
        let selectedLocation = CLLocation(latitude: touchMapCoord.latitude, longitude: touchMapCoord.longitude)
        selectedLocation.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            DispatchQueue.main.async {
                var cityTextfield: UITextField?
                var latTextfield: UITextField?
                var lonTextfield: UITextField?
                let alert = UIAlertController(title: "Add Favorite", message: "City/Lat/Long",
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { _ in
                    guard let city = cityTextfield?.text,
                            let lat = latTextfield?.text,
                          let lon = lonTextfield?.text,
                          let latDouble = Double(lat),
                          let lonDouble = Double(lon),
                          let uiTest = (UIApplication.shared.delegate as? AppDelegate)?.uiTest,
                          uiTest != true else {
                        return
                    }
                    let newFavorite = FavoritesModel(coordinate: ICoordinate(lat: latDouble, lon: lonDouble),
                                                     cityName: city)
                    self.delegate?.addNewFavorite(newFavorite)
                    self.mapView.addAnnotation(annot)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addTextField(configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = "City"
                    textField.text = placemark.neighborhood ??
                                    placemark.city ??
                                    placemark.county ??
                                    placemark.state ??
                                    placemark.country
                    textField.tag = 101
                    cityTextfield = textField
                })
                alert.addTextField(configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = "Latitude"
                    textField.text = "\(selectedLocation.coordinate.latitude)"
                    textField.tag = 102
                    latTextfield = textField
                })
                alert.addTextField(configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = "Longitude"
                    textField.text = "\(selectedLocation.coordinate.longitude)"
                    textField.tag = 103
                    lonTextfield = textField
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
