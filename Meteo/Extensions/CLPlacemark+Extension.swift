//
//  CLPlacemark+Extension.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/06.
//

import MapKit
import Contacts

extension CLPlacemark {
    var city: String? { locality }
    var neighborhood: String? { subLocality }
    var state: String? { administrativeArea }
    var county: String? { subAdministrativeArea }
}
