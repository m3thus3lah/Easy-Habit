//
//  JournalCreateViewController.swift
//  Easy Habit
//
//  Created by BJIT on 26/1/22.
//

import UIKit

class JournalCreateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var moodButtons: [UIButton]!
    @IBOutlet weak var moodBtnAnxious: UIButton!
    @IBOutlet weak var moodBtnConfused: UIButton!
    @IBOutlet weak var moodBtnAgitated: UIButton!
    @IBOutlet weak var moodBtnHappy: UIButton!
    @IBOutlet weak var moodBtnMischievous: UIButton!
    
    @IBOutlet weak var journalTitleTF: UITextField!
    @IBOutlet weak var titleErrorLabel: UILabel!
    @IBOutlet weak var detailsErrorLabel: UILabel!
    @IBOutlet weak var journalSaveBtn: UIButton!
    @IBOutlet weak var journalDetails: TextViewWithPlaceholder!
    @IBOutlet weak var journalCoverImage: UIImageView!
    @IBOutlet weak var coverImageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var changeImgBtn: UIButton!
    
    var observer: NSKeyValueObservation?
    var selectedMood: String? = nil
    var journalEntry: JournalEntry? = nil
    var didSelectCoverImg = false
    var editMode = false
    var refID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetForm()
        
        if journalEntry != nil {
            editMode = true
            showData()
        }
        
        observer = nil
        observer = journalCoverImage.observe(\.image, options: [.old, .new], changeHandler: { [weak self](imageView,_) in
            self?.didSelectCoverImg = true
            self?.checkForValidForm()
        })
        
        journalCoverImage.layer.cornerRadius = 10.0
        journalDetails.layer.cornerRadius = 10.0
        journalDetails.delegate = self
        
        journalDetails.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    func resetForm()
    {
        journalSaveBtn.isEnabled = false
        titleErrorLabel.isHidden = false
        detailsErrorLabel.isHidden = false
        
        titleErrorLabel.text = "80 characters"
        titleErrorLabel.textColor = UIColor(hex: "#09364F99")
        detailsErrorLabel.text = "800 characters"
        detailsErrorLabel.textColor = UIColor(hex: "#09364F99")
        
        journalTitleTF.text = ""
        journalDetails.text = ""
        
        journalCoverImage.isHidden = true
        coverImageHeight.constant = 0
        
        imageBtn.isHidden = false
        imageBtnHeight.constant = 40
        changeImgBtn.isHidden = true
        journalSaveBtn.isHidden = true
        
    }
    
    func showData(){
        
        if let journalEntry = journalEntry,
           let imageID = journalEntry.coverImgID,
           let title = journalEntry.title,
           let details = journalEntry.details,
           let mood = journalEntry.mood
        {
            if let image = LocalFileManager.shared.getImage(named: imageID) {
                
                print(journalEntry)
                journalCoverImage.image = image
                journalCoverImage.isHidden = false
                coverImageHeight.constant = 140
                imageBtn.isHidden = true
                imageBtnHeight.constant = 0
                changeImgBtn.isHidden = false
                
                refID = journalEntry.coverImgID!
                journalTitleTF.text = title
                journalDetails.insertText(details)
                selectedMood = mood
                setMoodButton(for: selectedMood!)
                journalSaveBtn.isHidden = false
                journalSaveBtn.isEnabled = true
            }
        }
    }
    
    func setMoodButton(for mood:String) {
        if mood == "moodHappy" {
            moodBtnHappy.backgroundColor = UIColor(hex: "#489EEFFF")
        }
        else if mood == "moodAnxious" {
            moodBtnAnxious.backgroundColor = UIColor(hex: "#489EEFFF")
        }
        else if mood == "moodAgitated" {
            moodBtnAgitated.backgroundColor = UIColor(hex: "#489EEFFF")
        }
        else if mood == "moodMischievous" {
            moodBtnMischievous.backgroundColor = UIColor(hex: "#489EEFFF")
        }
        else if mood == "moodConfused" {
            moodBtnConfused.backgroundColor = UIColor(hex: "#489EEFFF")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let details = journalDetails.text
        {
            if let errorMessage = UserInputValidator.invalidDetails(details)
            {
                detailsErrorLabel.text = errorMessage
                detailsErrorLabel.textColor = UIColor.red
                //detailsErrorLabel.isHidden = false
            }
            else
            {
                detailsErrorLabel.text = "800 characters"
                detailsErrorLabel.textColor = UIColor(hex: "#09364F99")
                //titleErrorLabel.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    @IBAction func titleDidChange(_ sender: Any) {
        if let title = journalTitleTF.text
        {
            if let errorMessage = UserInputValidator.invalidTitle(title)
            {
                titleErrorLabel.text = errorMessage
                titleErrorLabel.textColor = UIColor.red
                titleErrorLabel.isHidden = false
            }
            else
            {
                titleErrorLabel.text = "80 characters"
                titleErrorLabel.textColor = UIColor(hex: "#09364F99")
                //titleErrorLabel.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func checkForValidForm() {
        
        if didSelectCoverImg && journalDetails.text.count > 0 && journalTitleTF.text!.count > 0 && selectedMood != nil {
            journalSaveBtn.isEnabled = true
            journalSaveBtn.isHidden = false
        }
        else if editMode && journalDetails.text.count > 0 && journalTitleTF.text!.count > 0 {
            journalSaveBtn.isEnabled = true
            journalSaveBtn.isHidden = false
        }
        else {
            journalSaveBtn.isEnabled = false
            journalSaveBtn.isHidden = true
        }
        
    }
    
    func saveEntry(){
        
        if let title = journalTitleTF.text,
           let mood = selectedMood,
           let details = journalDetails.text,
           let image = journalCoverImage.image
        
        {
            if let imageID = LocalFileManager.shared.saveImage(image: image) {
                
                if !editMode {
                    let newJournalEntry = UserJournalEntry(title: title, mood: mood, coverImgID: imageID, details: details, date: Date())
                    
                    let savedData = CoreDataManager.shared.insertJournalEntry(entry: newJournalEntry)
                    print(savedData!)
                }
                else {
                    CoreDataManager.shared.updateJournalEntry(title: title, coverImgID: imageID, details: details, mood: mood, refID: refID!)
                    editMode = false
                    journalEntry = nil
                }
            }
        }
        resetForm()
    }
    
    @IBAction func didTapSaveBtn(_ sender: Any) {
        saveEntry()
        _ = navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func didTapMoodAnxiousBtn(_ sender: Any) {
        selectedMood = "moodAnxious"
        for i in 0 ... 4 {
            moodButtons[i].backgroundColor = UIColor(hex: "#F8F8FAFF")
        }
        moodBtnAnxious.backgroundColor = UIColor(hex: "#489EEFFF")
        checkForValidForm()
    }
    @IBAction func didTapMoodCofusedBtn(_ sender: Any) {
        selectedMood = "moodConfused"
        for i in 0 ... 4 {
            moodButtons[i].backgroundColor = UIColor(hex: "#F8F8FAFF")
        }
        moodBtnConfused.backgroundColor = UIColor(hex: "#489EEFFF")
        checkForValidForm()
    }
    @IBAction func didTapMoodAgitatedBtn(_ sender: Any) {
        selectedMood = "moodAgitated"
        for i in 0 ... 4 {
            moodButtons[i].backgroundColor = UIColor(hex: "#F8F8FAFF")
        }
        moodBtnAgitated.backgroundColor = UIColor(hex: "#489EEFFF")
        checkForValidForm()
    }
    @IBAction func didTapMoodHappyBtn(_ sender: Any) {
        selectedMood = "moodHappy"
        for i in 0 ... 4 {
            moodButtons[i].backgroundColor = UIColor(hex: "#F8F8FAFF")
        }
        moodBtnHappy.backgroundColor = UIColor(hex: "#489EEFFF")
        checkForValidForm()
    }
    @IBAction func didTapMoodMischievousBtn(_ sender: Any) {
        selectedMood = "moodMischievous"
        for i in 0 ... 4 {
            moodButtons[i].backgroundColor = UIColor(hex: "#F8F8FAFF")
        }
        moodBtnMischievous.backgroundColor = UIColor(hex: "#489EEFFF")
        checkForValidForm()
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapAddImage(_ sender: Any) {
        showPickImageActionSheet()
    }
    @IBAction func didTapChangeImage(_ sender: Any) {
        showPickImageActionSheet()
    }
    
}

extension JournalCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        journalCoverImage.image = image
        journalCoverImage.isHidden = false
        coverImageHeight.constant = 140
        imageBtn.isHidden = true
        imageBtnHeight.constant = 0
        changeImgBtn.isHidden = false
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
