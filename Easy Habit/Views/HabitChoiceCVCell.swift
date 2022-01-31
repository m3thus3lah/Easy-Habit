//
//  HabitChoiceCVCell.swift
//  Easy Habit
//
//  Created by BJIT on 27/1/22.
//

import UIKit


class HabitChoiceCVCell: UICollectionViewCell {

    static let identifier = "habitChoiceCVCell"
    @IBOutlet weak var habitChoiceCellBG: RoundEdgedView!
    @IBOutlet weak var habitChoiceCellImage: UIImageView!
    @IBOutlet weak var habitChoiceCellLabel: UILabel!
    @IBOutlet weak var habitSelectedBG: CircularView!
    @IBOutlet weak var habitSelectedNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with image: UIImage, label: String, isActive: Bool, serial: Int) {
        habitChoiceCellImage.image = image
        habitChoiceCellLabel.text = label
        
        if isActive {
            habitSelectedBG.isHidden = false
            habitSelectedNum.isHidden = false
            habitSelectedNum.text = String(serial)
        }
        else {
            habitSelectedBG.isHidden = true
            habitSelectedNum.isHidden = true
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HabitChoiceCVCell", bundle: nil)
    }

}
