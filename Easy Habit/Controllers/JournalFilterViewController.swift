//
//  JournalFilterViewController.swift
//  Easy Habit
//
//  Created by BJIT on 31/1/22.
//

import UIKit

protocol MoodFilterDelegate {
    func didChooseFilter(mood: String)
}

class JournalFilterViewController: UIViewController {

    
    @IBOutlet weak var anxiousBtn: UIButton!
    @IBOutlet weak var confusedBtn: UIButton!
    @IBOutlet weak var agitatedBtn: UIButton!
    @IBOutlet weak var happyBtn: UIButton!
    @IBOutlet weak var mischievousBtn: UIButton!
    
    var filterDelegate: MoodFilterDelegate!
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
    
    @IBAction func didTapAnxious(_ sender: Any) {
        //moodAnxious
        DispatchQueue.main.async{ [weak self] in
            self?.anxiousBtn.setImage(UIImage(named: "radioBtnON"), for: .normal)
        }
        filterDelegate.didChooseFilter(mood: "moodAnxious")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateDismiss()
        }
    }
    
    @IBAction func didTapConfused(_ sender: Any) {
        //moodConfused
        DispatchQueue.main.async{ [weak self] in
            self?.confusedBtn.setImage(UIImage(named: "radioBtnON"), for: .normal)
        }
        filterDelegate.didChooseFilter(mood: "moodConfused")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateDismiss()
        }
    }
    
    @IBAction func didTapAgitated(_ sender: Any) {
        //moodAgitated
        DispatchQueue.main.async{ [weak self] in
            self?.agitatedBtn.setImage(UIImage(named: "radioBtnON"), for: .normal)
        }
        filterDelegate.didChooseFilter(mood: "moodAgitated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateDismiss()
        }
    }
    
    @IBAction func didTapHappy(_ sender: Any) {
        //moodHappy
        DispatchQueue.main.async{ [weak self] in
            self?.happyBtn.setImage(UIImage(named: "radioBtnON"), for: .normal)
        }
        filterDelegate.didChooseFilter(mood: "moodHappy")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateDismiss()
        }
    }
    
    @IBAction func didTapMischievous(_ sender: Any) {
        //moodMischievous
        DispatchQueue.main.async{ [weak self] in
            self?.mischievousBtn.setImage(UIImage(named: "radioBtnON"), for: .normal)
        }
        filterDelegate.didChooseFilter(mood: "moodMischievous")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateDismiss()
        }
    }
    

}





