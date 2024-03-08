//
//  SideMenuOptionTableViewCell.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/06.
//

import UIKit

class SideMenuOptionTableViewCell: UITableViewCell {

    static let identifier = "sideMenuOptionCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    func fillUIWith(_ data: SideMenuOptionModel) {
        titleLabel.text = data.title
        iconImageView.image = data.image
    }

}
