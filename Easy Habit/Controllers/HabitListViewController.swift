//
//  HabitListViewController.swift
//  Easy Habit
//
//  Created by BJIT on 24/1/22.
//

import UIKit

class HabitListViewController: UIViewController {
    
    @IBOutlet weak var selectBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var habitNameLabel: UILabel!
    @IBOutlet weak var habitUnitLabel: UILabel!
    @IBOutlet weak var habitAmountLabel: UITextField!
    @IBOutlet weak var habitTimePicker: UIDatePicker!
    @IBOutlet weak var habitReminderBtn: UIButton!
    @IBOutlet weak var habitDetailsView: RoundedUpperRightEdgeView!
    @IBOutlet weak var changeHabitBtn: RoundEdgedButton!
    @IBOutlet weak var selectHabitBtn: RoundEdgedButton!
    @IBOutlet weak var selectButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var habitDaysBtnArray: [RoundEdgedButton]!{
        didSet {
            habitButtons.sort { $0.tag < $1.tag }
        }
    }
    
    @IBOutlet var habitButtons: [RoundEdgedButton]!{
        didSet {
            habitButtons.sort { $0.tag < $1.tag }
        }
    }
    
    @IBOutlet var habitLabels: [UILabel]!{
        didSet {
            habitLabels.sort { $0.tag < $1.tag }
        }
    }
    
    private var habits = [Habit]() //array of habits
    var selectedHabit: Habit! //selected habit
    var isChangeMode: Bool = false
    static let segueID = "habitListSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        //UserDefaultsManager.shared.setLastPhotoTakenDate(date: Date().dayBefore)
        loadDetails()
        print("habits view did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDetails ()
    }
    
    func loadDetails () {
        
        fetchData()
        if habits.count <= 0 {
            selectButtonTopConstraint.constant = 100
            habitDetailsView.isHidden = true
            selectHabitBtn.isHidden = false
            selectHabitBtn.isEnabled = true
            changeHabitBtn.isHidden = true
            changeHabitBtn.isEnabled = false
        } else {
            selectHabitBtn.isHidden = true
            selectHabitBtn.isEnabled = false
            changeHabitBtn.isHidden = false
            changeHabitBtn.isEnabled = true
            selectButtonTopConstraint.constant = 30
            changeHabitBtn.setTitle("Change Habits", for: .normal)
            habitDetailsView.isHidden = false
            habitButtons = habitButtons.sorted { $0.tag < $1.tag }
            habitLabels = habitLabels.sorted { $0.tag < $1.tag }
            habitDaysBtnArray = habitDaysBtnArray.sorted { $0.tag < $1.tag }
            renderTopBar(with: 0)
            renderHabitDetails(with: 0)
            selectedHabit = habits[0]
        }
    }
    
    private func fetchData() {
        
        if let results = CoreDataManager.shared.fetchAllActiveHabits() {
            habits = results
            habits = habits.sorted {habit1, habit2 in
                return habit1.serial < habit2.serial
            }
            print(habits.count)
        }
    }
    
    func renderTopBar(with index: Int) {
        
        var i = 0
        for habit in habits {
            if i == index {
                habitButtons[i].backgroundColor = UIColor(hex: "#2E91EDFF")
                habitButtons[i].tintColor = .white
                habitLabels[i].textColor = UIColor(hex: "#124D6EFF")
            } else {
                habitButtons[i].backgroundColor = UIColor(hex: "#F8F8FAFF")
                habitButtons[i].tintColor = UIColor(hex: "#6E91A6FF")
                habitLabels[i].textColor = UIColor(hex: "#124D6E99")
            }
            let image = UIImage(named: habit.imageID!)
            habitButtons[i].setImage(image, for: .normal)
            habitLabels[i].text = habit.name
            i += 1
        }
        
    }
    
    func renderHabitDetails(with index: Int) {
        
        guard let habitName = habits[index].name,
              let habitUnit = habits[index].unit,
              let habitTime = habits[index].time,
              let habitDays = habits[index].days else {
            return
        }
        
        let setReminder = habits[index].setReminder
        let amount = habits[index].amount
        
        habitNameLabel.text = habitName
        habitUnitLabel.text = habitUnit
        habitAmountLabel.text = String(amount)
        habitTimePicker.date = habitTime
        
        if setReminder {
            habitReminderBtn.setImage(UIImage(named: "reminderON"), for: .normal)
        } else {
            habitReminderBtn.setImage(UIImage(named: "reminderOFF"), for: .normal)
        }
        
        for i in 0...6 {
            if habitDays[i] {
                habitDaysBtnArray[i].tintColor = UIColor.white
                habitDaysBtnArray[i].setTitleColor(UIColor.white, for: .disabled)
                habitDaysBtnArray[i].backgroundColor = UIColor(hex: "#2E91EDFF")
            }
            else {
                habitDaysBtnArray[i].tintColor = UIColor(hex: "#09364FFF")
                habitDaysBtnArray[i].setTitleColor(UIColor(hex: "#09364FFF"), for: .disabled)
                habitDaysBtnArray[i].backgroundColor = UIColor.white
            }
        }

    }
    
    @IBAction func didTapHabit1(_ sender: Any) {
        let selectedIndex = 0
        selectedHabit = habits[selectedIndex]
        DispatchQueue.main.async{ [weak self] in
            self?.renderTopBar(with: selectedIndex)
            self?.renderHabitDetails(with: selectedIndex)
        }
        
    }
    @IBAction func didTapHabit2(_ sender: Any) {
        let selectedIndex = 1
        selectedHabit = habits[selectedIndex]
        DispatchQueue.main.async{ [weak self] in
            self?.renderTopBar(with: selectedIndex)
            self?.renderHabitDetails(with: selectedIndex)
        }
    }
    @IBAction func didTapHabit3(_ sender: Any) {
        let selectedIndex = 2
        selectedHabit = habits[selectedIndex]
        DispatchQueue.main.async{ [weak self] in
            self?.renderTopBar(with: selectedIndex)
            self?.renderHabitDetails(with: selectedIndex)
        }
    }
    @IBAction func didTapHabit4(_ sender: Any) {
        let selectedIndex = 3
        selectedHabit = habits[selectedIndex]
        DispatchQueue.main.async{ [weak self] in
            self?.renderTopBar(with: selectedIndex)
            self?.renderHabitDetails(with: selectedIndex)
        }
    }
    @IBAction func didTapHabit5(_ sender: Any) {
        let selectedIndex = 4
        selectedHabit = habits[selectedIndex]
        DispatchQueue.main.async{ [weak self] in
            self?.renderTopBar(with: selectedIndex)
            self?.renderHabitDetails(with: selectedIndex)
        }
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        print("add button clicked")
        isChangeMode = false
    }
    
    @IBAction func didTapChangeButton(_ sender: Any) {
        print("change button clicked")
        
        
        
        
        
        if let startDate = selectedHabit.startDate {
            
            let currentDate = Date()
            let habitAge = currentDate.days(from: startDate)
            print("##### \(habitAge)")
            
            if habitAge <= 5 {
                let alert = UIAlertController(title: "Cannot change this habit!", message: "You must maintain a habit for at least 5 days before changing it!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                isChangeMode = true
                performSegue(withIdentifier: HabitListViewController.segueID, sender: self)
            }
        }
        
    }
    
    @IBAction func didTapSelectButton(_ sender: Any) {
        print("select button clicked")
        isChangeMode = false
        performSegue(withIdentifier: HabitListViewController.segueID, sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == HabitListViewController.segueID {
            let destinationController = segue.destination as! HabitChoiceViewController
            print("##### before segue \(isChangeMode)")
            destinationController.isChangeMode = isChangeMode
            destinationController.selectedHabit = selectedHabit
            destinationController.oldHabit = selectedHabit
        }
        
    }

}
