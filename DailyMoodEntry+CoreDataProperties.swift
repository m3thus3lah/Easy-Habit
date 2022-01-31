//
//  DailyMoodEntry+CoreDataProperties.swift
//  Easy Habit
//
//  Created by BJIT on 28/1/22.
//
//

import Foundation
import CoreData


extension DailyMoodEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyMoodEntry> {
        return NSFetchRequest<DailyMoodEntry>(entityName: "DailyMoodEntry")
    }

    @NSManaged public var comment: String?
    @NSManaged public var date: Date?
    @NSManaged public var imageID: String?

}

extension DailyMoodEntry : Identifiable {

}
