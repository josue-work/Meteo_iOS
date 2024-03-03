//
//  TemperatureWithSubtitle.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import UIKit

@IBDesignable 
class TemperatureWithSubtitleView: UIView {
    
    @IBInspectable 
    var color: UIColor = .clear {
        didSet {
            self.backgroundColor = color
        }
    }

    @IBInspectable 
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable 
    var subtitle: String = "-" {
        didSet {
            self.subtitleLabel.text = subtitle
        }
    }
    
    @IBInspectable 
    var title: String = "---" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    @IBInspectable 
    var subtitleFont: UIFont? {
        didSet {
            self.subtitleLabel.font = subtitleFont
        }
    }
    
    @IBInspectable 
    var titleFont: UIFont? {
        didSet {
            self.titleLabel.font = titleFont
        }
    }
    
    @IBInspectable 
    var subtitleColor: UIColor? {
        didSet {
            self.subtitleLabel.textColor = subtitleColor
        }
    }
    
    @IBInspectable 
    var titleColor: UIColor? {
        didSet {
            self.titleLabel.textColor = titleColor
        }
    }
    
    var titleLabel: UILabel = UILabel()
    var subtitleLabel: UILabel = UILabel()
    
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center
        let centerTitleLabelConstraint = titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let topTitleLabelConstraint = titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4)
        let bottomTitleLabelConstraint = titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: 8)
        let centerSubtitleLabelConstraint = subtitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let bottomSubtitleLabelConstraint = subtitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 4)
        let leadingTitleLabelConstraint = titleLabel.leadingAnchor.constraint(lessThanOrEqualTo: self.leadingAnchor, constant: 8)
        let trailingTitleLabelConstraint = titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: 8)
        let leadingSubtitleLabelConstraint = subtitleLabel.leadingAnchor.constraint(lessThanOrEqualTo: self.leadingAnchor, constant: 8)
        let trailingSubtitleLabelConstraint = subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: 8)
        let subtitleLabelHeightConstraint = subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16)
        let titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        NSLayoutConstraint.activate([subtitleLabelHeightConstraint,
                                     titleLabelHeightConstraint,
                                     centerTitleLabelConstraint,
                                     topTitleLabelConstraint,
                                     bottomTitleLabelConstraint,
                                     centerSubtitleLabelConstraint,
                                     bottomSubtitleLabelConstraint,
                                     leadingTitleLabelConstraint,
                                     trailingTitleLabelConstraint,
                                     leadingSubtitleLabelConstraint,
                                     trailingSubtitleLabelConstraint
                                     ])
        self.clipsToBounds = false
    }
    
}
