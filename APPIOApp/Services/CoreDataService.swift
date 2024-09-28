//
//  CoreDataService.swift
//  APPIOApp
//
//  Created by Ваня Сокол on 25.09.2024.
//

import Foundation
import CoreData

final class CoreDataService {
    public static let shared = CoreDataService()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "APPIOApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() { }

    public func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
            }
        }
    }
    
    public func createItem(key: String,
                           state: BaseCellState,
                           insertIndex: Int,
                           selectedIndex: Int,
                           comparedIndex: Int,
                           isCorrectWord: Bool) {
        let newItem = SavedWord(context: context)
        newItem.key = key
        newItem.cellState = state.rawValue
        newItem.insertIndex = Int16(insertIndex)
        newItem.selectedIndex = Int16(selectedIndex)
        newItem.comparedIndex = Int16(comparedIndex)
        newItem.isCorrectWord = isCorrectWord

        do {
            try context.save()
        } catch {
            print("Create error",error)
        }
    }
    
    public func createItem(key: String, state: BaseCellState, gameParameters: GameParameters, selectedIndex: Int) {
        let newItem = SavedWord(context: context)
        newItem.key = key
        newItem.cellState = state.rawValue
        newItem.insertIndex = Int16(gameParameters.insertIndex)
        newItem.selectedIndex = Int16(selectedIndex)
        newItem.comparedIndex = Int16(gameParameters.comparedIndex)
        newItem.isCorrectWord = gameParameters.isCorrectWord

        do {
            try context.save()
        } catch {
            print("Create error",error)
        }
    }

    public func getAllItems() -> [SavedWord] {
        do {
            return (try? context.fetch(SavedWord.fetchRequest()) as? [SavedWord]) ?? []
        }
    }
    
    public func deleteAllItems() {
        let items = getAllItems()
        items.forEach { context.delete($0)}

        do {
            try context.save()
        } catch {
            print("Delete all items error", error)
        }
    }
}
