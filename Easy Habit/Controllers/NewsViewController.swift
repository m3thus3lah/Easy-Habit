//
//  NewsViewController.swift
//  Easy Habit
//
//  Created by BJIT on 25/1/22.
//

import UIKit
import Alamofire
import AlamofireImage

class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsCV: UICollectionView!
    @IBOutlet weak var newsTV: UITableView!
    @IBOutlet weak var newsTVHeight: NSLayoutConstraint!
    @IBOutlet weak var newsScrollView: UIScrollView!
    
    static let segueId = "newsSegue"
    var screenWidth: CGFloat!
    var newsArticles: [Article] = []
    var selectedNewsArticle: Article?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 3, left: 24, bottom: 3, right: 0)
        layout.itemSize = CGSize(width: screenWidth-80, height: 200)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 8
        newsCV.collectionViewLayout = layout
        
        newsCV.delegate = self
        newsCV.dataSource = self
        newsTV.delegate = self
        newsTV.dataSource = self
        newsScrollView.delegate = self
        
        newsCV.register(NewsCVCell.nib(), forCellWithReuseIdentifier: NewsCVCell.identifier)
        newsTV.register(NewsTVCell.nib(), forCellReuseIdentifier: NewsTVCell.identifier)
        
        APICaller.shared.getTopStories { [self] result in
            switch result {
            case .success(let response):
                newsArticles = response
                DispatchQueue.main.async {
                    self.newsTV.reloadData()
                    self.newsCV.reloadData()
                }
                break
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newsCV.reloadData()
        newsTV.reloadData()
    }
    
    @IBAction func didTapFilterBtn(_ sender: Any) {
        
    }
    
     //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == NewsViewController.segueId {
            let destinationController = segue.destination as! NewsDetailViewController
            destinationController.article = selectedNewsArticle
            print(selectedNewsArticle!)
        }
    }
    
}

//extension NewsViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.contentOffset.x = 0.0
//    }
//}

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNewsArticle = newsArticles[indexPath.row]
        performSegue(withIdentifier: NewsViewController.segueId, sender: self)
    }
    
}

extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //newsTVHeight.constant = CGFloat(Double(cellHeight * Double(newsArticles.count)))
        return newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tvCell = newsTV.dequeueReusableCell(withIdentifier: NewsTVCell.identifier, for: indexPath) as! NewsTVCell
        
        let newsArticle = newsArticles[indexPath.row]
        var image = UIImage(named: "imageNotFound")
        let headline = newsArticle.title
        let date = newsArticle.publishedAt
        var author = "author name unavaiblable"
        if let value = newsArticle.author {
            author = value
        }
        
        //tvCell.tvCellImage.image = UIImage(named: "imageNotFound")
        tvCell.tvCellheadline.text = headline
        tvCell.tvCellDate.text = date + " by " + author
        
        if let imageURL  = newsArticle.urlToImage {
            AF.request("\(imageURL)").responseData { (response) in
                if response.error == nil
                {
                    if let data = response.data {
                        image = UIImage(data: data)
                        tvCell.tvCellImage.image = image
                    }
                }
            }
        }
        
        let tvCellHeight = Double(tvCell.bounds.height)
        newsTVHeight.constant = CGFloat(Double(tvCellHeight * Double(newsArticles.count)))
        return tvCell
    }
    
}

extension NewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedNewsArticle = newsArticles[indexPath.row]
        performSegue(withIdentifier: NewsViewController.segueId, sender: self)
        print(indexPath)
    }
}

extension NewsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cvCell = newsCV.dequeueReusableCell(withReuseIdentifier: NewsCVCell.identifier, for: indexPath) as! NewsCVCell
        
        let newsArticle = newsArticles[indexPath.row]
        var image = UIImage(named: "imageNotFound")
        let headline = newsArticle.title
        //let date = newsArticle.publishedAt
        var author = "Author name unavaiblable"
        if let value = newsArticle.author {
            author = value
        }
        
        //cvCell.cvCellImg.image = UIImage(named: "imageNotFound")
        cvCell.cvCellHeadline.text = headline
        cvCell.cvCellAuthor.text = author
    
        if let imageURL  = newsArticle.urlToImage {
            AF.request("\(imageURL)").responseData { (response) in
                if response.error == nil
                {
                    if let data = response.data {
                        image = UIImage(data: data)
                        cvCell.cvCellImg.image = image
                    }
                }
            }
        }
        return cvCell
    }
    
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth-80, height: 200)
    }
    
}
