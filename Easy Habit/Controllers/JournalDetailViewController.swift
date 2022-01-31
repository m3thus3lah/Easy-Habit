//
//  JournalDetailViewController.swift
//  Easy Habit
//
//  Created by BJIT on 26/1/22.
//

import UIKit

class JournalDetailViewController: UIViewController {
    
    @IBOutlet weak var journalDetailScrollView: UIScrollView!
    @IBOutlet weak var journalDetailImage: UIImageView!
    @IBOutlet weak var journalDetailTitle: UILabel!
    @IBOutlet weak var journalDetailText: UILabel!
    @IBOutlet weak var joiurnalDetailMoodImg: UIImageView!
    @IBOutlet weak var journalDetailDate: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    let segueID = "editSegue"
    var selectedEntry: JournalEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        journalDetailScrollView.layer.cornerRadius = 90.0
        journalDetailScrollView.layer.maskedCorners = [.layerMaxXMinYCorner]
        journalDetailImage.layer.cornerRadius = 10.0

        if let date = selectedEntry.date,
           let imageID = selectedEntry.coverImgID,
           let text = selectedEntry.details,
           let title = selectedEntry.title,
           let mood = selectedEntry.mood {
            
            let dateString = Utility.formatDate(for: date, with: "MMM dd")
            
            journalDetailTitle.text = title
            journalDetailText.text = text
            journalDetailDate.text = dateString
            
            if let image = LocalFileManager.shared.getImage(named: imageID) {
                journalDetailImage.image = image
            }
            if let image = UIImage(named: mood) {
                joiurnalDetailMoodImg.image = image
            }
            
        }
        
        let currentDate = Date()
        let journalDate = selectedEntry.date!
        let isTodaysEntry = Calendar.current.isDate(currentDate, equalTo: journalDate, toGranularity: .day)
        
        if isTodaysEntry {
            editBtn.isEnabled = true
            editBtn.isHidden = false
        }
        else {
            editBtn.isEnabled = false
            editBtn.isHidden = true
        }
        
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        //performSegue(withIdentifier: segueID, sender: self)
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            let destinationController = segue.destination as! JournalCreateViewController
            destinationController.journalEntry = selectedEntry
        }
    }
    
}
