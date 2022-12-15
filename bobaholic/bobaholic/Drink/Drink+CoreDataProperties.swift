//
//  Drink+CoreDataProperties.swift
//  bobaholic
//

import Foundation
import CoreData


extension Drink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }

    @NSManaged public var ice: String?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var price: Double
    @NSManaged public var rating: Double
    @NSManaged public var recommend: String?
    @NSManaged public var sugar: String?
    @NSManaged public var toppings: String?
    @NSManaged public var shop: Shop?
    @NSManaged public var order: NSSet?

}

// MARK: Generated accessors for order
extension Drink {

    @objc(addOrderObject:)
    @NSManaged public func addToOrder(_ value: Order)

    @objc(removeOrderObject:)
    @NSManaged public func removeFromOrder(_ value: Order)

    @objc(addOrder:)
    @NSManaged public func addToOrder(_ values: NSSet)

    @objc(removeOrder:)
    @NSManaged public func removeFromOrder(_ values: NSSet)

}

extension Drink : Identifiable {

}
