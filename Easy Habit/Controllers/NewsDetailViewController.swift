//
//  NewsDetailViewController.swift
//  Easy Habit
//
//  Created by BJIT on 25/1/22.
//

import UIKit
import Alamofire
import AlamofireImage

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var newsDetailScrollView: UIScrollView!
    @IBOutlet weak var newsDetailImage: UIImageView!
    @IBOutlet weak var newsDetailHeadline: UILabel!
    @IBOutlet weak var newsDetailLabel: UILabel!
    @IBOutlet weak var newsDetailDate: UILabel!
    
    var article: Article?
    var newsURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        newsDetailScrollView.layer.cornerRadius = 90.0
        newsDetailScrollView.layer.maskedCorners = [.layerMaxXMinYCorner]
        newsDetailImage.layer.cornerRadius = 10.0
    
        newsDetailHeadline.text = article?.title
        newsDetailLabel.text = article?.description
        newsDetailDate.text = article?.publishedAt
        
        newsURL = article?.url
        
        if let imageURL  = article?.urlToImage {
            AF.request("\(imageURL)").responseData { [weak self] (response) in
                if response.error == nil
                {
                    if let data = response.data {
                        self?.newsDetailImage.image = UIImage(data: data)
                    }
                }
            }
        }
        
    }
    
    @IBAction func didTapReadMore(_ sender: Any) {
        if let urlString = newsURL,
           let url = URL(string: urlString){
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

}
