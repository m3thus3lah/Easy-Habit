//
//  Model.swift
//  Easy Habit
//
//  Created by BJIT on 22/1/22.
//

import Foundation

struct UserInfo {
    var name : String
    var dateOfBirth : String
    var wakeUpTime : String
}

struct DayMoodEntry {
    var comment: String?
    var imageID: String?
    var date: Date?
}

struct UserJournalEntry {
    var title: String?
    var mood: String?
    var coverImgID: String?
    var details: String?
    var date: Date?
}

struct HabitData {
    var habitID: String?
    var name: String?
    var imageID: String?
    var btnImgID: String?
    var isCustom: Bool?
    var isActive: Bool
    var unit: String?
    var amount: Int?
    var days: [Bool]?
    var serial: Int?
    var setReminder: Bool
    var startDate: Date?
    var time: Date?
}

extension HabitData {
    static var defaultHabits = [
        HabitData(habitID: "add", name: "Add Custom", imageID: "habitCustomAdd", btnImgID: "habitCustomAdd", isCustom: false, isActive: false, unit: nil, amount: nil, days: nil, serial: nil, setReminder: false, startDate: nil, time: nil),
        HabitData(habitID: "read", name: "Reading Book", imageID: "habitRead", btnImgID: "habitReadSelected", isCustom: false, isActive: false, unit: "pages", amount: nil, days: nil, serial: nil, setReminder: false, startDate: nil, time: nil),
        HabitData(habitID: "walk", name: "Walking", imageID: "habitWalk", btnImgID: "habitWalkSelected", isCustom: false, isActive: false, unit: "mins", amount: nil, days: nil, serial: nil, setReminder: false, startDate: nil, time: nil),
        HabitData(habitID: "drinkwater", name: "Drinking Water", imageID: "habitWater", btnImgID: "habitWaterSelected", isCustom: false, isActive: false, unit: "litters", amount: nil, days: nil, serial: nil, setReminder: false, startDate: nil, time: nil),
        HabitData(habitID: "run", name: "Running", imageID: "habitRun", btnImgID: "habitRunSelected", isCustom: false, isActive: false, unit: "mins", amount: nil, days: nil, serial: nil, setReminder: false, startDate: nil, time: nil),
        HabitData(habitID: "watchtv", name: "Watching TV", imageID: "habitTV", btnImgID: "habitTVSelected", isCustom: false, isActive: false, unit: "mins", amount: nil, days: nil, serial: nil, setReminder: false, startDate: nil, time: nil),
        HabitData(habitID: "exc", name: "Excercise", imageID: "habitExercise", btnImgID: "habitExerciseSelected", isCustom: false, isActive: false, unit: "mins", amount: nil, days: nil, serial: nil, setReminder: false, startDate: nil, time: nil),
        HabitData(habitID: "call", name: "Call to Family", imageID: "habitCall", btnImgID: "habitCallSelected", isCustom: false, isActive: false, unit: "mins", amount: nil, days: nil, serial: nil, setReminder: false, startDate: nil, time: nil),
        HabitData(habitID: "takefood", name: "Taking Food", imageID: "habitFood", btnImgID: "habitFoodSelected", isCustom: false, isActive: false, unit: "calories", amount: nil, days: nil, serial: nil, setReminder: false, startDate: nil, time: nil)
    ]
}
