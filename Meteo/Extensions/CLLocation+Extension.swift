//
//  CLLocation+Extension.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/06.
//

import MapKit

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
