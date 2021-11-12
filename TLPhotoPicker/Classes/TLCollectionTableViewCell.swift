//
//  TLCollectionTableViewCell.swift
//  TLPhotosPicker
//
//  Created by wade.hawk on 2017. 5. 3..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import UIKit

open class TLCollectionTableViewCell: UITableViewCell {
    @IBOutlet open var thumbImageView: UIImageView!
    @IBOutlet open var titleLabel: UILabel!
    @IBOutlet open var subTitleLabel: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()   
        if #available(iOS 11.0, *) {
            self.thumbImageView.accessibilityIgnoresInvertColors = true
        }
        self.thumbImageView.layer.cornerRadius = 10.0
        self.thumbImageView.layer.masksToBounds = true
        self.contentView.backgroundColor = .clear
        self.titleLabel.textColor = UIColor(red: 33/255, green: 38/255, blue: 44/255, alpha: 1)
        self.subTitleLabel.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        self.titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        self.subTitleLabel.font = .systemFont(ofSize: 14, weight: .light)
    }
}
