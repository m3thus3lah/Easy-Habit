//
//  GalleryViewController.swift
//  Easy Habit
//
//  Created by BJIT on 24/1/22.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var filterLabelBtn: UIButton!
    
    private var entries = [DailyMoodEntry]()
    var selectedEntry: DailyMoodEntry!
    static let segueId = "gallerySegue"
    static let filterSegueId = "filterSegue"
    var screenWidth: CGFloat!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.itemSize = CGSize(width: screenWidth/4.2, height: screenWidth/4.2)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        galleryCollectionView.collectionViewLayout = layout
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        galleryCollectionView.register(GalleryCollectionViewCell.nib(),
                                       forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        
        if let results = CoreDataManager.shared.fetchAllDailyMoodEntries() {
            entries = results.sorted {entry1, entry2 in
                return entry1.date! > entry2.date!
            }
        }
    }
    
    @IBAction func didTapFilterBtn(_ sender: Any) {
        let filterVC = UIStoryboard(name: "Gallery", bundle: nil).instantiateViewController(withIdentifier: "filterVC") as! GalleryFilterViewController
        filterVC.filterDelegate = self
        self.addChild(filterVC)
        filterVC.view.frame = self.view.frame
        self.view.addSubview(filterVC.view)
        filterVC.didMove(toParent: self)
    }
    
     //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GalleryViewController.segueId {
            let destinationController = segue.destination as! GalleryDetailViewController
            destinationController.selectedEntry = selectedEntry
        }
    }
    
}

extension GalleryViewController: FilterDelegate {
    func didChooseFilter(numberOfDays: Int, filterLabel: String) {
        
        filterLabelBtn.setTitle(filterLabel, for: .normal)
        
        if numberOfDays == 1 {
            if let results = CoreDataManager.shared.fetchAllDailyMoodEntries() {
                entries = results.sorted{entry1, entry2 in
                    return entry1.date! > entry2.date!
                }
                galleryCollectionView.reloadData()
            }
        } else {
            if let results = CoreDataManager.shared.fetchAllDailyMoodEntries(filterByDays: numberOfDays) {
                entries = results.sorted{entry1, entry2 in
                    return entry1.date! > entry2.date!
                }
                galleryCollectionView.reloadData()
            }
        }
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedEntry = entries[indexPath.row]
        performSegue(withIdentifier: GalleryViewController.segueId, sender: self)
        print(indexPath)
    }
    
}

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as! GalleryCollectionViewCell
        
        guard let date = entries[indexPath.row].date,
              let imageID = entries[indexPath.row].imageID else {
            return cell
        }
        
        let dateString = Utility.formatDate(for: date, with: "dd MMM")
 
        if let image = LocalFileManager.shared.getImage(named: imageID) {
            cell.configure(with: image, date: dateString!)
        }
        
        return cell
    }
    
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/4.2, height: screenWidth/4.2);
    }
    
}
