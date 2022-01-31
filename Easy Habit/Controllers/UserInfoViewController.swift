//
//  UserInfoViewController.swift
//  Easy Habit
//
//  Created by BJIT on 22/1/22.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var userInfoBGView: UIView!
    @IBOutlet weak var nameTextField: PaddedTextField!
    @IBOutlet weak var dobTextField: PaddedTextField!
    @IBOutlet weak var wakeUpTimePicker: UIDatePicker!
    @IBOutlet weak var continueButton: RoundEdgedButton!
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var dobError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetForm()
    }
    
}

extension UserInfoViewController {
    
    func resetForm()
    {
        continueButton.isEnabled = false
        nameError.isHidden = false
        dobError.isHidden = false
        //wakeUpTimeError.isHidden = false
        
        nameError.text = "Required"
        dobError.text = "Required"
        
        nameTextField.text = ""
        dobTextField.text = ""
        
    }
    
    @IBAction func continueBtnTapped(_ sender: Any) {
        
        if let name = nameTextField.text,
           let dateOfBirth = dobTextField.text,
           let wakeUpTime = Utility.formatDate(for: wakeUpTimePicker.date, with: "HHmm")
        
        {
            let userInfo = UserInfo(name: name, dateOfBirth: dateOfBirth, wakeUpTime: wakeUpTime)
            UserDefaultsManager.shared.setUserInfo(userInfo: userInfo)
            UserDefaultsManager.shared.setUserRegistrationStatus(didFinishRegistration: true) 
            UserDefaultsManager.shared.setLastPhotoTakenDate(date: Date().dayBefore) //at first time launch, this value will be set to a past date to avoid errors
        }
        
        resetForm()
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        if let name = nameTextField.text
        {
            if let errorMessage = UserInputValidator.invalidName(name)
            {
                nameError.text = errorMessage
                nameError.isHidden = false
            }
            else
            {
                nameError.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    @IBAction func dobChanged(_ sender: Any) {
        
        if let dob = dobTextField.text
        {
            if let errorMessage = UserInputValidator.invalidDoB(dob)
            {
                dobError.text = errorMessage
                dobError.isHidden = false
            }
            else
            {
                dobError.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func checkForValidForm()
    {
        if nameError.isHidden && dobError.isHidden
        {
            continueButton.isEnabled = true
        }
        else
        {
            continueButton.isEnabled = false
        }
    }
    
}



