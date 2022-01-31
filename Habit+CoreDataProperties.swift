//
//  Habit+CoreDataProperties.swift
//  Easy Habit
//
//  Created by BJIT on 28/1/22.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var btnImgID: String?
    @NSManaged public var habitID: String?
    @NSManaged public var imageID: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var isCustom: Bool
    @NSManaged public var name: String?
    @NSManaged public var unit: String?
    @NSManaged public var amount: Int64
    @NSManaged public var days: [Bool]?
    @NSManaged public var serial: Int64
    @NSManaged public var setReminder: Bool
    @NSManaged public var startDate: Date?
    @NSManaged public var time: Date?

}

extension Habit : Identifiable {

}
