//
//  GalleryDetailViewController.swift
//  Easy Habit
//
//  Created by BJIT on 25/1/22.
//

import UIKit

class GalleryDetailViewController: UIViewController {
    
    @IBOutlet weak var galleryDetailImage: UIImageView!
    @IBOutlet weak var galleryDetailComments: UITextView!
    @IBOutlet weak var galleryDetailDateLabel: UILabel!
    
    var selectedEntry: DailyMoodEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        galleryDetailImage.layer.cornerRadius = 70
        galleryDetailImage.layer.maskedCorners = [.layerMaxXMinYCorner]
        galleryDetailComments.layer.cornerRadius = 10
        galleryDetailComments.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        if let date = selectedEntry.date,
           let imageID = selectedEntry.imageID,
           let comment = selectedEntry.comment {
        
            var dateString: String!
            if Calendar.current.isDateInToday(date) {
                dateString = "Today"
            }
            else {
                dateString = Utility.formatDate(for: date, with: "EEEE, dd LLLL, yyyy")
            }
            
            if let image = LocalFileManager.shared.getImage(named: imageID) {
                galleryDetailImage.image = image
                galleryDetailComments.text = comment
                galleryDetailDateLabel.text = dateString
            }
            
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}


