//
//  CoreDataManager.swift
//  Easy Habit
//
//  Created by BJIT on 23/1/22.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {} // Prevent the creation of another instance.
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Easy_Habit")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //MARK: - Day Mood
    func insertDailyMoodEntry(dayMoodEntry: DayMoodEntry) -> DailyMoodEntry?
    {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DailyMoodEntry", in: managedContext)!
        let dailyMoodEntry = NSManagedObject(entity: entity, insertInto: managedContext)
        
        dailyMoodEntry.setValue(dayMoodEntry.comment, forKeyPath: "comment")
        dailyMoodEntry.setValue(dayMoodEntry.imageID, forKeyPath: "imageID")
        dailyMoodEntry.setValue(dayMoodEntry.date, forKeyPath: "date")
        
        do {
            try managedContext.save()
            return dailyMoodEntry as? DailyMoodEntry
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func updateDailyMoodEntry(comment: String, imageID: String, dailyMoodEntry : DailyMoodEntry) {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
         
        do {
            dailyMoodEntry.setValue(comment, forKeyPath: "comment")
            dailyMoodEntry.setValue(imageID, forKeyPath: "imageID")
            try context.save()
            print("saved!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    func deleteDailyMoodEntry(dailyMoodEntry : DailyMoodEntry){
        
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        
        do {
            managedContext.delete(dailyMoodEntry)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteDailyMoodEntry(with imageID: String) -> [DailyMoodEntry]? {

        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DailyMoodEntry")

        fetchRequest.predicate = NSPredicate(format: "imageID == %@" ,imageID)
        do {

            let entries = try managedContext.fetch(fetchRequest)
            var arrRemovedEntries = [DailyMoodEntry]()
            for entry in entries {

                managedContext.delete(entry)
                try managedContext.save()
                arrRemovedEntries.append(entry as! DailyMoodEntry)
            }
            return arrRemovedEntries

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchAllDailyMoodEntries() -> [DailyMoodEntry]?{
        
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DailyMoodEntry")
        
        do {
            let entries = try managedContext.fetch(fetchRequest)
            return entries as? [DailyMoodEntry]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchAllDailyMoodEntries(filterByDays numberOfDays: Int) -> [DailyMoodEntry]?{
        
        print(numberOfDays)
        
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DailyMoodEntry")
    
        if numberOfDays == 0 {
            
            let currentDate = Date()
            let startDate = currentDate.startOfDay
            let endDate = currentDate.endOfDay
            fetchRequest.predicate = NSPredicate(format:"(date > %@) AND (date <= %@)", startDate as NSDate, endDate as NSDate)
        }
        else if numberOfDays == -1 {
            let currentDate = Date()
            let yesterday = currentDate.dayBefore
            let startDate = yesterday.startOfDay
            let endDate = yesterday.endOfDay
            fetchRequest.predicate = NSPredicate(format:"(date > %@) AND (date <= %@)", startDate as NSDate, endDate as NSDate)
        }
        else {
            let currentDate = Date()
            let startDate = Calendar.current.date(byAdding: .day, value: numberOfDays, to: currentDate)!
            fetchRequest.predicate = NSPredicate(format:"(date > %@) AND (date <= %@)", startDate as NSDate, currentDate as NSDate)
        }
        
        do {
            let entries = try managedContext.fetch(fetchRequest)
            return entries as? [DailyMoodEntry]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    
    //MARK: - Habit
    
    func loadDefaultHabits() {
        
        let habits = HabitData.defaultHabits
        for habit in habits {
            _ = addHabit(habit: habit)
        }
    }
    
    private func addHabit(habit: HabitData) -> Habit? {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Habit", in: managedContext)!
        let newHabit = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newHabit.setValue(habit.name, forKey: "name")
        newHabit.setValue(habit.habitID, forKey: "habitID")
        newHabit.setValue(habit.imageID, forKey: "imageID")
        newHabit.setValue(habit.btnImgID, forKey: "btnImgID")
        newHabit.setValue(habit.isActive, forKey: "isActive")
        newHabit.setValue(habit.isCustom, forKey: "isCustom")
        newHabit.setValue(habit.unit, forKey: "unit")
        newHabit.setValue(habit.serial, forKey: "serial")
        newHabit.setValue(habit.amount, forKey: "amount")
        newHabit.setValue(habit.startDate, forKey: "startDate")
        newHabit.setValue(habit.setReminder, forKey: "setReminder")
        newHabit.setValue(habit.time, forKey: "time")
        newHabit.setValue(habit.days, forKey: "days")
        
        do {
            try managedContext.save()
            return newHabit as? Habit
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func addCustomHabit(with habitName: String) -> NSManagedObject? {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Habit", in: managedContext)!
        let customHabit = NSManagedObject(entity: entity, insertInto: managedContext)
    
        let uniqueID = Utility.uniqueID()
        customHabit.setValue(habitName, forKey: "name")
        customHabit.setValue(uniqueID, forKey: "habitID")
        customHabit.setValue("habitCustom", forKey: "imageID")
        customHabit.setValue("habitCustomSelected", forKey: "btnImgID")
        customHabit.setValue(true, forKey: "isCustom")
        customHabit.setValue("mins", forKey: "unit")
        
        customHabit.setValue(false, forKey: "isActive")
        customHabit.setValue(nil, forKey: "serial")
        customHabit.setValue(nil, forKey: "amount")
        customHabit.setValue(nil, forKey: "startDate")
        customHabit.setValue(false, forKey: "setReminder")
        customHabit.setValue(nil, forKey: "time")
        customHabit.setValue(nil, forKey: "days")
        
        do {
            try managedContext.save()
            return customHabit as? Habit
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchAllHabits() -> [Habit]? {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Habit")
        
        do {
            let habits = try managedContext.fetch(fetchRequest)
            return habits as? [Habit]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchAllActiveHabits() -> [Habit]? {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Habit")
        
        fetchRequest.predicate = NSPredicate(format:"isActive == %@", NSNumber(value: true))
        do {
            let userHabits = try managedContext.fetch(fetchRequest)
            return userHabits as? [Habit]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func setHabit(habit: Habit, habitData: HabitData) -> Habit? {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
         
        do {
            
            habit.setValue(habitData.isActive, forKeyPath: "isActive")
            habit.setValue(habitData.serial, forKey: "serial")
            habit.setValue(habitData.amount, forKey: "amount")
            habit.setValue(habitData.startDate, forKey: "startDate")
            habit.setValue(habitData.setReminder, forKey: "setReminder")
            habit.setValue(habitData.time, forKey: "time")
            habit.setValue(habitData.days, forKey: "days")
            
            try context.save()
            print("saved!")
            return habit
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return nil
        }

    }
    
    func resetHabit(habit: Habit) -> Habit? {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
         
        do {
            
            habit.setValue(false, forKeyPath: "isActive")
            habit.setValue(nil, forKey: "serial")
            habit.setValue(nil, forKey: "amount")
            habit.setValue(nil, forKey: "startDate")
            habit.setValue(false, forKey: "setReminder")
            habit.setValue(nil, forKey: "time")
            habit.setValue(nil, forKey: "days")
            try context.save()
            print("saved!")
            return habit
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return nil
        }

    }
    
    //MARK: - Journal
    func fetchAllJournalEntries() -> [JournalEntry]?{
        
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "JournalEntry")
        
        do {
            let entries = try managedContext.fetch(fetchRequest)
            return entries as? [JournalEntry]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchAllJournalEntries(filterByMood mood: String) -> [JournalEntry]?{
        
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "JournalEntry")
        
        fetchRequest.predicate = NSPredicate(format:"mood == %@", mood)
        //format: "name CONTAINS[cd] %@", "David"
        //fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", mood)
        do {
            let entries = try managedContext.fetch(fetchRequest)
            return entries as? [JournalEntry]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func insertJournalEntry(entry: UserJournalEntry) -> JournalEntry?
    {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "JournalEntry", in: managedContext)!
        let journalEntry = NSManagedObject(entity: entity, insertInto: managedContext)
        
        journalEntry.setValue(entry.title, forKey: "title")
        journalEntry.setValue(entry.coverImgID, forKey: "coverImgID")
        journalEntry.setValue(entry.details, forKey: "details")
        journalEntry.setValue(entry.mood, forKey: "mood")
        journalEntry.setValue(entry.date, forKey: "date")
        
        do {
            try managedContext.save()
            return journalEntry as? JournalEntry
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func updateJournalEntry(title: String, coverImgID: String, details: String, mood: String, refID: String) {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "JournalEntry")
        fetchRequest.predicate = NSPredicate(format: "coverImgID == %@", refID)
        
        do {
            let journalEntries = try context.fetch(fetchRequest)
            let journalEntry = journalEntries[0]
            journalEntry.setValue(title, forKey: "title")
            journalEntry.setValue(coverImgID, forKey: "coverImgID")
            journalEntry.setValue(details, forKey: "details")
            journalEntry.setValue(mood, forKey: "mood")
            
            try context.save()
            print("saved!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    func updateJournalEntry(title: String, coverImgID: String, details: String, mood: String, journalEntry: JournalEntry) {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        do {
            journalEntry.setValue(title, forKey: "title")
            journalEntry.setValue(coverImgID, forKey: "coverImgID")
            journalEntry.setValue(details, forKey: "details")
            journalEntry.setValue(mood, forKey: "mood")
            
            try context.save()
            print("saved!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
}
