//
//  HabitChoiceViewController.swift
//  Easy Habit
//
//  Created by BJIT on 27/1/22.
//

import UIKit

class HabitChoiceViewController: UIViewController {
    
    @IBOutlet weak var habitChoiceCV: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    
    static let choiceSegueId = "addDetailSegue"
    var screenWidth: CGFloat!
    
    var isChangeMode: Bool!
    private var habits = [Habit]() //array of habits
    var selectedHabit: Habit! //selected habit
    var oldHabit: Habit! //selected habit
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
        layout.itemSize = CGSize(width: (screenWidth/2)-34, height: 120)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        
        habitChoiceCV.delegate = self
        habitChoiceCV.dataSource = self
        habitChoiceCV.collectionViewLayout = layout
        habitChoiceCV.register(HabitChoiceCVCell.nib(),
                               forCellWithReuseIdentifier: HabitChoiceCVCell.identifier)
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        habitChoiceCV.reloadData()
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == HabitChoiceViewController.choiceSegueId {
            let destinationController = segue.destination as! HabitAddEditVC
            print(selectedHabit!)
            destinationController.isChangeMode = isChangeMode
            destinationController.selectedHabit = selectedHabit
            destinationController.oldHabit = oldHabit
            isChangeMode = false
        }
    }
    
}

extension HabitChoiceViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("\(UserDefaultsManager.shared.getHabitCount())")
        
        if indexPath == [0,0] {
            addCustomHabit()
            //these lines are needed if app should segue to next page automatically after adding a new habit
            //need to fetch the last added entry and set that as selectedHabit
            //performSegue(withIdentifier: HabitChoiceViewController.choiceSegueId, sender: self)
        }
        else if UserDefaultsManager.shared.getHabitCount() < 5
        {
            DispatchQueue.main.async{ [weak self] in
                self?.errorView.isHidden = true
            }
            if habits[indexPath.row].isActive {
                let alert = UIAlertController(title: "Habit already added!", message: "You are already commited to following this habit!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                selectedHabit = habits[indexPath.row]
                performSegue(withIdentifier: HabitChoiceViewController.choiceSegueId, sender: self)
            }

        }
        else if UserDefaultsManager.shared.getHabitCount() >= 5 && !isChangeMode
        {
            DispatchQueue.main.async{ [weak self] in
                self?.errorView.isHidden = false
            }
            print("you cannot choose more than 5 habits")
        }
        else if UserDefaultsManager.shared.getHabitCount() == 5 && isChangeMode {
            selectedHabit = habits[indexPath.row]
            performSegue(withIdentifier: HabitChoiceViewController.choiceSegueId, sender: self)
        }
        
    }
    
}

extension HabitChoiceViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(habits.count)
        return habits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = habitChoiceCV.dequeueReusableCell(withReuseIdentifier: HabitChoiceCVCell.identifier, for: indexPath) as! HabitChoiceCVCell
        
        guard let label = habits[indexPath.row].name,
              let imageID = habits[indexPath.row].imageID else {
            print("no data found")
            return cell
        }
        
        let isActive = habits[indexPath.row].isActive
        let serial = habits[indexPath.row].serial
        
        if let image = UIImage(named: imageID) {
            cell.configure(with: image, label: label, isActive: isActive, serial: Int(serial))
        }
        return cell
    }
    
}

extension HabitChoiceViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth/2)-34, height: 120)
    }
    
}

extension HabitChoiceViewController {
    
    private func fetchData() {
        
        if let results = CoreDataManager.shared.fetchAllHabits() { //fetch all habits
            habits = results
            habits = habits.sorted {habit1, habit2 in
                if habit1.habitID == "add" {
                    return true
                }else if habit2.habitID == "add" {
                    return false
                }
                return habit1.habitID! < habit2.habitID!
            }
            print(habits.count)
        }
    }
    
    private func addCustomHabit() {
        
        let alert = UIAlertController(
            title: "Please insert custom habit name",
            message: nil,
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { field in
            field.placeholder = "Habit name"
            field.returnKeyType = .continue
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            guard let fields = alert.textFields, fields.count == 1 else {
                return
            }
            let habitNameField = fields[0]
            guard let habitName = habitNameField.text, !habitName.isEmpty else {
                let alert = UIAlertController(title: "Invalid habit name", message: "Please insert a valid name for habit!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            _ = CoreDataManager.shared.addCustomHabit(with: habitName)
            self.fetchData()
            self.habitChoiceCV.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
        //throw alert with input field for new habit name [DONE]
        //add new habit to core data entity for Habit [DONE]
        //set selected entry  = new custom entry [IS THIS REQUIRED?]
        //perform segue [DONE]
    }
    
}
