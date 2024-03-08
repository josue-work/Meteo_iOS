//
//  FavoritesTableViewCell.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/06.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    static let identifier = "favoritesCell"

    @IBOutlet weak var titleLabel: UILabel!

    func fillUIWith(_ data: FavoritesModel) {
        titleLabel.text = data.cityName
    }
}
