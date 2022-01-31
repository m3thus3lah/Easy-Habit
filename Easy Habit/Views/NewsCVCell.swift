//
//  NewsCVCell.swift
//  Easy Habit
//
//  Created by BJIT on 25/1/22.
//

import UIKit

class NewsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var cvCellImg: UIImageView!
    @IBOutlet weak var cvCellHeadline: UILabel!
    @IBOutlet weak var cvCellAuthor: UILabel!
    static let identifier = "newsCVCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cvCellImg.layer.cornerRadius = 10.0
    }
    
    public func configure(with image: UIImage?, headline: String, author: String) {
        if let image = image {
            cvCellImg.image = image
        }
        else {
            cvCellImg.image = UIImage(named: "imageNotFound")
        }
        cvCellHeadline.text = headline
        cvCellAuthor.text = author
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "NewsCVCell", bundle: nil)
    }

}
