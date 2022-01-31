//
//  GalleryCollectionViewCell.swift
//  Easy Habit
//
//  Created by BJIT on 24/1/22.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var galleryCellImage: UIImageView!
    @IBOutlet weak var galleryCellDateLabel: UILabel!
    
    static let identifier = "galleryCVCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with image: UIImage, date: String) {
        galleryCellImage.image = image
        galleryCellDateLabel.text = date
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "GalleryCollectionViewCell", bundle: nil)
    }

}
