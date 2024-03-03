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
    
}
