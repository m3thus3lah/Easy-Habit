//
//  SceneDelegate.swift
//  Easy Habit
//
//  Created by BJIT on 21/1/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if UserDefaultsManager.shared.userDidFinishRegistration() {
            //user already completed registration
            print("user has already completed registration")
            let currentDate = Date()
            let lastPictureTakenDate = UserDefaultsManager.shared.getLastPhotoTakenDate()!
            let sameDay = Calendar.current.isDate(currentDate, equalTo: lastPictureTakenDate, toGranularity: .day)
            let currentTime = Int(Utility.formatDate(for: Date(), with: "HHmm")!)!
            guard let wakeUpTime = Int(UserDefaultsManager.shared.getWakeUpTime()!) else {
                print("could not find wake up time!")
                return
            }
            
            if !sameDay && currentTime >= wakeUpTime {
                //user hasn't taken a Day Mood photo in the last 24 hours (starting from wake up time)
                print("user hasn't taken a Day Mood photo in the last 24 hours (starting from wake up time)")
                let storyboard = UIStoryboard(name: "DayMood", bundle: nil)
                window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "DayMood")
            }
            else if (!sameDay && currentTime < wakeUpTime) || sameDay {
                //user has taken a Day Mood photo in the last 24 hours (starting from wake up time)
                print("user has taken a Day Mood photo in the last 24 hours (starting from wake up time)")
                let storyboard = UIStoryboard(name: "HabitList", bundle: nil)
                window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "HabitList")
            }
            else {
                print("an undefined scenario has occured!")
            }
            
            //MARK: - For test purpose
            print("last picture taken \(lastPictureTakenDate)")
            print("current day  \(currentDate)")
            print("isSameday = \(sameDay)")
            print("wake up time = \(wakeUpTime)")
            print("currentTime = \(currentTime)")
            print("habit count = \(UserDefaultsManager.shared.getHabitCount())")
            
        }
        else {
            print("first time launching the app, user needs to register")
            //first time launching the app, user needs to register
            CoreDataManager.shared.loadDefaultHabits()
            UserDefaultsManager.shared.setLastPhotoTakenDate(date: Date().dayBefore)
            UserDefaultsManager.shared.setHabitCount(count: 0)
            
            //MARK: - For test purpose
            print("last picture taken \(UserDefaultsManager.shared.getLastPhotoTakenDate()!)")
            print("habit count = \(UserDefaultsManager.shared.getHabitCount())")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "GetStarted")
        }
        print(Utility.applicationDirectoryPath())
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        CoreDataManager.shared.saveContext()
    }


}

