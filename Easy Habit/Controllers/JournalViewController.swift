//
//  JournalViewController.swift
//  Easy Habit
//
//  Created by BJIT on 26/1/22.
//

import UIKit

class JournalViewController: UIViewController {

    @IBOutlet weak var journalCV: UICollectionView!
    @IBOutlet weak var filterEmojiBG: RoundEdgedView!
    @IBOutlet weak var filterEmojiImage: UIImageView!
    @IBOutlet weak var filterClearBtn: UIButton!
    @IBOutlet weak var fiterEmojiBGHeight: NSLayoutConstraint!
    @IBOutlet weak var filterEmojiImageHeight: NSLayoutConstraint!
    
    private var entries = [JournalEntry]()
    var selectedEntry: JournalEntry!
    static let detailSegueId = "journalDetailSegue"
    var screenWidth: CGFloat!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        filterEmojiImageHeight.constant = 0
        fiterEmojiBGHeight.constant = 0
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
        layout.itemSize = CGSize(width: screenWidth-52, height: 180)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        
        journalCV.delegate = self
        journalCV.dataSource = self
        journalCV.collectionViewLayout = layout
        journalCV.register(JournalCollectionViewCell.nib(),
                                       forCellWithReuseIdentifier: JournalCollectionViewCell.identifier)
        
        if let results = CoreDataManager.shared.fetchAllJournalEntries() {
            entries = results.sorted {entry1, entry2 in
                return entry1.date! > entry2.date!
            }
            print(entries.count)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let results = CoreDataManager.shared.fetchAllJournalEntries() {
            entries = results.sorted {entry1, entry2 in
                return entry1.date! > entry2.date!
            }
            print(entries.count)
        }
        journalCV.reloadData()
        filterEmojiBG.isHidden = true
        filterClearBtn.isHidden = true
        filterEmojiImageHeight.constant = 0
        fiterEmojiBGHeight.constant = 0
    }
    
    @IBAction func ddiTapFilterBtn(_ sender: Any) {
        let filterVC = UIStoryboard(name: "Journal", bundle: nil).instantiateViewController(withIdentifier: "moodFilterVC") as! JournalFilterViewController
        filterVC.filterDelegate = self
        self.addChild(filterVC)
        filterVC.view.frame = self.view.frame
        self.view.addSubview(filterVC.view)
        filterVC.didMove(toParent: self)
    }
    
    @IBAction func didTapClearFilter(_ sender: Any) {
        filterEmojiBG.isHidden = true
        filterClearBtn.isHidden = true
        filterEmojiImageHeight.constant = 0
        fiterEmojiBGHeight.constant = 0
        
        if let results = CoreDataManager.shared.fetchAllJournalEntries() {
            entries = results.sorted {entry1, entry2 in
                return entry1.date! > entry2.date!
            }
            print(entries.count)
        }
        journalCV.reloadData()
    }
    
     //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == JournalViewController.detailSegueId {
            let destinationController = segue.destination as! JournalDetailViewController
            destinationController.selectedEntry = selectedEntry
        }
    }
    
}

extension JournalViewController: MoodFilterDelegate {
    func didChooseFilter(mood: String) {
        print(mood)

        if let results = CoreDataManager.shared.fetchAllJournalEntries(filterByMood: mood) {
            entries = results.sorted {entry1, entry2 in
                return entry1.date! > entry2.date!
            }
            print(entries.count)
        }
        journalCV.reloadData()
        filterEmojiBG.isHidden = false
        filterClearBtn.isHidden = false
        fiterEmojiBGHeight.constant = 58
        filterEmojiImageHeight.constant = 32
        filterEmojiImage.image = UIImage(named: mood)
    }
}

extension JournalViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedEntry = entries[indexPath.row]
        performSegue(withIdentifier: JournalViewController.detailSegueId, sender: self)
        print(indexPath)
    }
    
}

extension JournalViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = journalCV.dequeueReusableCell(withReuseIdentifier: JournalCollectionViewCell.identifier, for: indexPath) as! JournalCollectionViewCell
        
        guard let date = entries[indexPath.row].date,
              let imageID = entries[indexPath.row].coverImgID,
              let title = entries[indexPath.row].title else {
            return cell
        }
        
        let dateString = Utility.formatDate(for: date, with: "dd MMM")
        if let image = LocalFileManager.shared.getImage(named: imageID) {
            cell.configure(with: image, date: dateString!, title: title)
        }
        
        return cell
    }
    
}

extension JournalViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth-52, height: 180);
    }
    
}

