//
//  UserDefaultsManager.swift
//  Easy Habit
//
//  Created by BJIT on 23/1/22.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults(suiteName: "com.easyhabit.user.info")
    
    //var pictureTakenDay: String!
    
    private init() {}
    
    func resetUserDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    func userDidFinishRegistration() -> Bool {
        //will be used to keep track of whether the user finished registrasion or not
        if let value = defaults?.value(forKey: "didFinishRegistration") as? Bool {
            return value
        }
        return false
    }
    
    func userDidTakeDailyPhoto() -> Bool {
        if let value = defaults?.value(forKey: "didTakePhoto") as? Bool {
            return value
        }
        return false
    }
    
    func userDidSaveDailyPhoto() -> Bool {
        if let value = defaults?.value(forKey: "didSavePhoto") as? Bool {
            return value
        }
        return false
    }
    
    func getLastPhotoTakenDate() -> Date? {
        if let date = defaults?.value(forKey: "pictureTakenDate") as? Date {
            return date
        }
        return nil
    }
    
    func getHabitCount() -> Int {
        if let count = defaults?.value(forKey: "habitCount") as? Int {
            return count
        }
        return 0
    }
    
    func setHabitCount(count: Int) {
        defaults?.setValue(count, forKey: "habitCount")
    }
    
    func getUserName() -> String? {
        if let name = defaults?.value(forKey: "name") as? String {
            return name
        }
        return nil
    }
    
    func getDateOfBirth() -> String? {
        if let dateOfBirth = defaults?.value(forKey: "dateOfBirth") as? String {
            return dateOfBirth
        }
        return nil
    }
    
    func getWakeUpTime() -> String? {
        if let wakeUpTime = defaults?.value(forKey: "wakeUpTime") as? String {
            return wakeUpTime
        }
        return nil
    }
    
    func setUserRegistrationStatus(didFinishRegistration: Bool) {
        defaults?.setValue(didFinishRegistration, forKey: "didFinishRegistration")
    }
    
    func setDailyPhotoStatus(didTakePhoto: Bool) {
        defaults?.setValue(didTakePhoto, forKey: "didTakePhoto")
    }
    
    func setDailyPhotoStatus(didSavePhoto: Bool) {
        defaults?.setValue(didSavePhoto, forKey: "didSavePhoto")
    }
    
    func setLastPhotoTakenDate(date: Date){
        defaults?.setValue(date, forKey: "pictureTakenDate")
    }
    
    func setUserName(name: String) {
        defaults?.setValue(name, forKey: "name")
    }
    
    func setDateOfBirth(dateOfBirth: String) {
        defaults?.setValue(dateOfBirth, forKey: "dateOfBirth")
    }
    
    func setWakeUpTime(wakeUpTime: String) {
        defaults?.setValue(wakeUpTime, forKey: "wakeUpTime")
    }
    
    func setUserInfo(userInfo: UserInfo) {
        setUserName(name: userInfo.name)
        setDateOfBirth(dateOfBirth: userInfo.dateOfBirth)
        setWakeUpTime(wakeUpTime: userInfo.wakeUpTime)
    }
    
    func getUserInfo() -> UserInfo? {
        
        guard let name = getUserName(),
              let dateOfBirth = getDateOfBirth(),
              let wakeUpTime = getWakeUpTime() else {
            return nil
        }
        let userInfo = UserInfo(name: name, dateOfBirth: dateOfBirth, wakeUpTime: wakeUpTime)
        return userInfo
        
    }
    
}
