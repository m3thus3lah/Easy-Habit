//
//  JournalEntry+CoreDataProperties.swift
//  Easy Habit
//
//  Created by BJIT on 28/1/22.
//
//

import Foundation
import CoreData


extension JournalEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalEntry> {
        return NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
    }

    @NSManaged public var coverImgID: String?
    @NSManaged public var date: Date?
    @NSManaged public var details: String?
    @NSManaged public var mood: String?
    @NSManaged public var title: String?

}

extension JournalEntry : Identifiable {

}
