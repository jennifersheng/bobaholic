//
//  Shop+CoreDataProperties.swift
//  bobaholic
//

import Foundation
import CoreData


extension Shop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shop> {
        return NSFetchRequest<Shop>(entityName: "Shop")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var drink: NSSet?

}

// MARK: Generated accessors for drink
extension Shop {

    @objc(addDrinkObject:)
    @NSManaged public func addToDrink(_ value: Drink)

    @objc(removeDrinkObject:)
    @NSManaged public func removeFromDrink(_ value: Drink)

    @objc(addDrink:)
    @NSManaged public func addToDrink(_ values: NSSet)

    @objc(removeDrink:)
    @NSManaged public func removeFromDrink(_ values: NSSet)

}

extension Shop : Identifiable {

}
