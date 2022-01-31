//
//  HabitAddEditVC.swift
//  Easy Habit
//
//  Created by BJIT on 27/1/22.
//

import UIKit
import UserNotifications

class HabitAddEditVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var habitAmount: UITextField!
    @IBOutlet weak var habitUnit: UILabel!
    @IBOutlet weak var habitTimePicker: UIDatePicker!
    @IBOutlet weak var amountError: UILabel!
    @IBOutlet weak var repeatError: UILabel!
    @IBOutlet weak var setTimeError: UILabel!
    @IBOutlet weak var addHabitButton: RoundEdgedButton!
    @IBOutlet weak var habitNameLabel: UILabel!
    @IBOutlet weak var habitUnitLabel: UILabel!
    @IBOutlet weak var habitReminderBtn: UIButton!
    
    @IBOutlet var dayButtons: [RoundEdgedButton]! {
        didSet {
            dayButtons.sort { $0.tag < $1.tag }
        }
    }
    
    var isChangeMode: Bool!
    var selectedHabit: Habit! //selected habit
    var oldHabit: Habit! //selected habit
    var numberOfRepeatingDays: Int!
    var setReminder = false
    var selectedDays = [false, false, false, false, false, false, false] {
        willSet {
            print(numberOfRepeatingDays!)
            if numberOfRepeatingDays == 0 {
                //repeatError.isHidden = false
                repeatError.text = "* At least one day must be selected!"
            } else {
                //repeatError.isHidden = true
                repeatError.text = "* Required field"
                checkForValidForm()
            }
        }
    }
    
    var isValidAmount: Bool!
    var isValidRepeat: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(selectedHabit!)
        //habitTimePicker.timeZone = .current
        habitNameLabel.text = selectedHabit.name
        habitUnitLabel.text = selectedHabit.unit
        habitAmount.delegate = self
        dayButtons = dayButtons.sorted { $0.tag < $1.tag }
        resetForm()
        
    }
    
    func resetForm() {
        
        addHabitButton.isEnabled = false
        numberOfRepeatingDays = 0
        setReminder = false
        habitAmount.text = ""
        habitTimePicker.date = Date()
        for button in dayButtons {
            button.tintColor = UIColor(hex: "#09364FFF")
            button.backgroundColor = UIColor.white
        }
        selectedDays = [false, false, false, false, false, false, false]
        repeatError.isHidden = false
        repeatError.text = "* Required field"
        amountError.isHidden = false
        amountError.text = "* Required field"
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @IBAction func amountChanged(_ sender: Any) {
        
        if let habitAmount = habitAmount.text {
            
            guard let value = Int(habitAmount) else {
                amountError.text = "* Required field"
                return
            }
            
            print(value)
            
            if value <= 0 {
                amountError.text = "* Value must be greater than 0"
            } else if value > 0 {
                print("amount valid")
                //amountError.isHidden = true
                amountError.text = "* Required field"
            } else {
                amountError.text = "* Required field"
            }
        }
    }
    
    func checkForValidForm() {
        
        guard let repeatError = repeatError.text,
              let amountError = amountError.text,
              let setTimeError = setTimeError.text else {
            return
        }
        
        if repeatError.count == amountError.count && amountError.count == setTimeError.count && setTimeError.count == 16 {
            addHabitButton.isEnabled = true
        } else {
            addHabitButton.isEnabled = false
        }
        
    }
    
    func addHabit() {
        let habitData = HabitData(
            isActive: true,
            amount: Int(habitAmount.text!),
            days: selectedDays,
            serial: UserDefaultsManager.shared.getHabitCount() + 1,
            setReminder: setReminder,
            startDate: Date(),
            time: habitTimePicker.date)
        
        //after habit data has been updated in core data, change values of the user defaults
        if let newHabit = CoreDataManager.shared.setHabit(habit: selectedHabit, habitData: habitData) {
            print(newHabit)
            let newCount = UserDefaultsManager.shared.getHabitCount() + 1
            UserDefaultsManager.shared.setHabitCount(count: newCount)
        }
    }
    
    func updateHabit () {
        let habitData = HabitData(
            isActive: true,
            amount: Int(habitAmount.text!),
            days: selectedDays,
            serial: Int(oldHabit.serial),
            setReminder: setReminder,
            startDate: Date(),
            time: habitTimePicker.date)
        
        //after habit data has been updated in core data, change values of the user defaults
        if let newHabit = CoreDataManager.shared.setHabit(habit: selectedHabit, habitData: habitData) {
            print(newHabit)
        }
        
        if let replacedHabit = CoreDataManager.shared.resetHabit(habit: oldHabit) {
            print(replacedHabit)
        }
    }
    
    func setReminders() {
        var weekday = 1
        for day in selectedDays {
            if day {
                print("setReminders() weekday: \(weekday)")
            
                let pickerDate = habitTimePicker.date
                let calendar = Calendar.current
                let localdate = calendar.date(byAdding: .hour, value: 6, to: pickerDate)!
                
                let date = createDate(date: localdate, weekday: weekday)
                print("setReminders() created date with weekday: \(date)")
                let title = "Easy Habit | " + habitNameLabel.text! + habitUnitLabel.text!
                let body = "It's time for you to maintain your habit!"
                //scheduleReminder(title: title, body: body, date: date)
                scheduleReminder(title: title, body: body, date: pickerDate)
            }
            weekday += 1
        }
    }
    
    func createDate(date: Date, weekday: Int) -> Date {

        print("createDate() picker date: \(date)")
        print("createDate() weekday: \(weekday)")
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let year = calendar.component(.year, from: date)

        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.year = year
        components.weekday = weekday // sunday = 1 ... saturday = 7
        components.timeZone = .current

        return calendar.date(from: components)!
        
    }
    
    func scheduleReminder(title: String, body: String, date:Date) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        //let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
        let triggerWeekly = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if let error = error {
                print(error)
            }
        })
        
    }
    
    @IBAction func didSelectSunday(_ sender: Any) {
        if !selectedDays[0] {
            numberOfRepeatingDays += 1
            selectedDays[0] = true
            dayButtons[0].tintColor = UIColor.white
            dayButtons[0].backgroundColor = UIColor(hex: "#2E91EDFF")
        }
        else {
            numberOfRepeatingDays -= 1
            selectedDays[0] = false
            dayButtons[0].tintColor = UIColor(hex: "#09364FFF")
            dayButtons[0].backgroundColor = UIColor.white
        }
    }
    @IBAction func didSelectMonday(_ sender: Any) {
        if !selectedDays[1] {
            numberOfRepeatingDays += 1
            selectedDays[1] = true
            dayButtons[1].tintColor = UIColor.white
            dayButtons[1].backgroundColor = UIColor(hex: "#2E91EDFF")
        }
        else {
            numberOfRepeatingDays -= 1
            selectedDays[1] = false
            dayButtons[1].tintColor = UIColor(hex: "#09364FFF")
            dayButtons[1].backgroundColor = UIColor.white
        }
    }
    @IBAction func didSelectTuesday(_ sender: Any) {
        if !selectedDays[2] {
            numberOfRepeatingDays += 1
            selectedDays[2] = true
            dayButtons[2].tintColor = UIColor.white
            dayButtons[2].backgroundColor = UIColor(hex: "#2E91EDFF")
        }
        else {
            numberOfRepeatingDays -= 1
            selectedDays[2] = false
            dayButtons[2].tintColor = UIColor(hex: "#09364FFF")
            dayButtons[2].backgroundColor = UIColor.white
        }
    }
    @IBAction func didSelectWednesday(_ sender: Any) {
        if !selectedDays[3] {
            numberOfRepeatingDays += 1
            selectedDays[3] = true
            dayButtons[3].tintColor = UIColor.white
            dayButtons[3].backgroundColor = UIColor(hex: "#2E91EDFF")
        }
        else {
            numberOfRepeatingDays -= 1
            selectedDays[3] = false
            dayButtons[3].tintColor = UIColor(hex: "#09364FFF")
            dayButtons[3].backgroundColor = UIColor.white
        }
    }
    @IBAction func didSelectThursday(_ sender: Any) {
        if !selectedDays[4] {
            numberOfRepeatingDays += 1
            selectedDays[4] = true
            dayButtons[4].tintColor = UIColor.white
            dayButtons[4].backgroundColor = UIColor(hex: "#2E91EDFF")
        }
        else {
            numberOfRepeatingDays -= 1
            selectedDays[4] = false
            dayButtons[4].tintColor = UIColor(hex: "#09364FFF")
            dayButtons[4].backgroundColor = UIColor.white
        }
    }
    @IBAction func didSelectFriday(_ sender: Any) {
        if !selectedDays[5] {
            numberOfRepeatingDays += 1
            selectedDays[5] = true
            dayButtons[5].tintColor = UIColor.white
            dayButtons[5].backgroundColor = UIColor(hex: "#2E91EDFF")
        }
        else {
            numberOfRepeatingDays -= 1
            selectedDays[5] = false
            dayButtons[5].tintColor = UIColor(hex: "#09364FFF")
            dayButtons[5].backgroundColor = UIColor.white
        }
    }
    @IBAction func didSelectSaturday(_ sender: Any) {
        if !selectedDays[6] {
            numberOfRepeatingDays += 1
            selectedDays[6] = true
            dayButtons[6].tintColor = UIColor.white
            dayButtons[6].backgroundColor = UIColor(hex: "#2E91EDFF")
        }
        else {
            numberOfRepeatingDays -= 1
            selectedDays[6] = false
            dayButtons[6].tintColor = UIColor(hex: "#09364FFF")
            dayButtons[6].backgroundColor = UIColor.white
        }
    }
    
    @IBAction func didToggleReminder(_ sender: Any) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { success, error in
            if success {
                //schedule test
            } else if let error = error {
                print(error)
            }
        })
        
        if setReminder == true {
            setReminder = false
            habitReminderBtn.setImage(UIImage(named: "reminderOFF"), for: .normal)
            
        } else {
            setReminder = true
            habitReminderBtn.setImage(UIImage(named: "reminderON"), for: .normal)
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapAddHabit(_ sender: Any) {
        
        if isChangeMode && oldHabit != nil && UserDefaultsManager.shared.getHabitCount() > 0 {
            updateHabit()
            isChangeMode = false
        } else {
            addHabit()
        }
        
        if setReminder {
            setReminders()
        }
        resetForm()
        _ = navigationController?.popViewController(animated: true)
    }

}
