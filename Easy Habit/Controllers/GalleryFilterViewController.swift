//
//  GalleryFilterViewController.swift
//  Easy Habit
//
//  Created by BJIT on 30/1/22.
//

import UIKit

protocol FilterDelegate {
    func didChooseFilter(numberOfDays: Int, filterLabel: String)
}

class GalleryFilterViewController: UIViewController {
    
    @IBOutlet weak var filterBtnAll: UIButton!
    @IBOutlet weak var filterBtn7: UIButton!
    @IBOutlet weak var filterBtn15: UIButton!
    @IBOutlet weak var filterBtn30: UIButton!
    @IBOutlet weak var filterBtnToday: UIButton!
    @IBOutlet weak var filterBtnYesterday: UIButton!
    
    var filterDelegate: FilterDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.animatePopup()
    }
    
    func animatePopup()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func animateDismiss()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @IBAction func didTapAllTime(_ sender: Any) {
        DispatchQueue.main.async{ [weak self] in
            self?.filterBtnAll.setImage(UIImage(named: "radioBtnON"), for: .normal)
        }
        filterDelegate.didChooseFilter(numberOfDays: 1, filterLabel: "All time ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateDismiss()
        }
    }
    
    @IBAction func didTap7Days(_ sender: Any) {
        DispatchQueue.main.async{ [weak self] in
            self?.filterBtn7.setImage(UIImage(named: "radioBtnON"), for: .normal)
        }
        filterDelegate.didChooseFilter(numberOfDays: -7, filterLabel: "Last 7 days ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateDismiss()
        }
    }
    
    @IBAction func didTap15Days(_ sender: Any) {
        DispatchQueue.main.async{ [weak self] in
            self?.filterBtn15.setImage(UIImage(named: "radioBtnON"), for: .normal)
        }
        filterDelegate.didChooseFilter(numberOfDays: -15, filterLabel: "Last 15 days ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateDismiss()
        }
    }
    
    @IBAction func didTap30Days(_ sender: Any) {
        DispatchQueue.main.async{ [weak self] in
            self?.filterBtn30.setImage(UIImage(named: "radioBtnON"), for: .normal)
        }
        filterDelegate.didChooseFilter(numberOfDays: -30, filterLabel: "Last 30 days ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateDismiss()
        }
    }
    
    @IBAction func didTapToday(_ sender: Any) {
        DispatchQueue.main.async{ [weak self] in
            self?.filterBtnToday.setImage(UIImage(named: "radioBtnON"), for: .normal)
        }
        filterDelegate.didChooseFilter(numberOfDays: 0, filterLabel: "Today ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateDismiss()
        }
    }
    
    @IBAction func didTapYesterday(_ sender: Any) {
        DispatchQueue.main.async{ [weak self] in
            self?.filterBtnYesterday.setImage(UIImage(named: "radioBtnON"), for: .normal)
        }
        filterDelegate.didChooseFilter(numberOfDays: -1, filterLabel: "Yesterday ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateDismiss()
        }
    }
    
}
