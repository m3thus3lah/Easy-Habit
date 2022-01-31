//
//  DayMoodViewController.swift
//  Easy Habit
//
//  Created by BJIT on 23/1/22.
//

import UIKit

class DayMoodViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var dayMoodComment: TextViewWithPlaceholder!
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var commentErrorLabel: UILabel!
    
    var observer: NSKeyValueObservation?
    var userDidTakePhoto: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultsManager.shared.setDailyPhotoStatus(didSavePhoto: false)
        dayMoodComment.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        commentErrorLabel.isHidden = false
        dailyImageView.layer.cornerRadius = 70
        dailyImageView.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        print(LocalFileManager.documentDirectoryURL)
        
        observer = nil
        observer = dailyImageView.observe(\.image, options: [.old, .new], changeHandler: { [weak self](imageView,_) in
            self?.userDidTakePhoto = true
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let userDidSavePhoto = UserDefaultsManager.shared.userDidSaveDailyPhoto()
        
        if !userDidSavePhoto {
            userDidTakePhoto = false
        }
        
    }
    
    @IBAction func didTapAddImageBtn(_ sender: Any) {
        showPickImageActionSheet()
    }
    
    @IBAction func didTapSaveBtn(_ sender: Any) {
        
        if dayMoodInputsAreValid() {
            saveDailyCommentsAndImage()
        }
    }
    
    
    func dayMoodInputsAreValid() -> Bool {
        
        let textLength = dayMoodComment.text.count
        
        if !userDidTakePhoto && textLength < 1 {
            let alert = UIAlertController(title: "Photo and comment missing!", message: "You must add a photo and add a comment before you can continue!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if !userDidTakePhoto {
            let alert = UIAlertController(title: "Photo missing!", message: "You must add a photo before you can continue!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if textLength < 1 {
            let alert = UIAlertController(title: "Comment missing!", message: "You must write a comment before you can continue!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if textLength > 0 && userDidTakePhoto {
            return true
        }
        return false
        
    }
    
}

extension DayMoodViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showPickImageActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: {action in
            self.pickImage(option: "camera")
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: {action in
            self.pickImage(option: "gallery")
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func pickImage(option choice: String) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if choice == "camera" {
            if Utility.isRunningOnSimulator() {
                let alert = UIAlertController(title: "Camera not available", message: "Camera is unavailable while the app is running on simulator!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }else {
                picker.sourceType = .camera
            }
        }
        else if choice == "gallery" {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        dailyImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension DayMoodViewController {
    
    func saveDailyCommentsAndImage() {
        
        guard let comment = dayMoodComment.text else {
            return
        }
        
        guard let image = dailyImageView.image else {
            return
        }

        guard let imageID = LocalFileManager.shared.saveImage(image: image) else {
            return
        }
        UserDefaultsManager.shared.setDailyPhotoStatus(didSavePhoto: true)
        UserDefaultsManager.shared.setLastPhotoTakenDate(date: Date())
        
        let date = Date()
        print(imageID)
        let dayMoodEntry = DayMoodEntry(comment: comment, imageID: imageID, date: date)
        let savedData = CoreDataManager.shared.insertDailyMoodEntry(dayMoodEntry: dayMoodEntry)
        print("day mood entry saved!")
        //print(savedData!)

    }
}
