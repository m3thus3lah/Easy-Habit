//
//  NewsTVCell.swift
//  Easy Habit
//
//  Created by BJIT on 25/1/22.
//

import UIKit

class NewsTVCell: UITableViewCell {
    
    @IBOutlet weak var tvCellheadline: UILabel!
    @IBOutlet weak var tvCellImage: UIImageView!
    @IBOutlet weak var tvCellDate: UILabel!
    
    static let identifier = "newsTVCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tvCellImage.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(with image: UIImage?, headline: String, date: String, author: String) {
        
        if let image = image {
            tvCellImage.image = image
        }
        else {
            tvCellImage.image = UIImage(named: "imageNotFound")
        }
        tvCellheadline.text = headline
        tvCellDate.text = date + " by " + author
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "NewsTVCell", bundle: nil)
    }
    
}
