//
//  SavedWord+CoreDataProperties.swift
//  APPIOApp
//
//  Created by Ваня Сокол on 25.09.2024.
//
//

import Foundation
import CoreData

@objc(SavedWord)
public class SavedWord: NSManagedObject { }

extension SavedWord {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedWord> {
        return NSFetchRequest<SavedWord>(entityName: "SavedWord")
    }

    @NSManaged public var key: String
    @NSManaged public var cellState: String
    @NSManaged public var insertIndex: Int16
    @NSManaged public var selectedIndex: Int16
    @NSManaged public var isCorrectWord: Bool
    @NSManaged public var comparedIndex: Int16
}

extension SavedWord : Identifiable { }
