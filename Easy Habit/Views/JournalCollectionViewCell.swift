//
//  JournalCollectionViewCell.swift
//  Easy Habit
//
//  Created by BJIT on 26/1/22.
//

import UIKit

class JournalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "journalCVCell"
    
    @IBOutlet weak var journalCellImage: UIImageView!
    @IBOutlet weak var journalCellDateLabel: UILabel!
    @IBOutlet weak var journalCellTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        journalCellImage.layer.cornerRadius = 10.0
    }
    
    public func configure(with image: UIImage, date: String, title: String) {
        journalCellImage.image = image
        journalCellDateLabel.text = date
        journalCellTitleLabel.text = title
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "JournalCollectionViewCell", bundle: nil)
    }

}
