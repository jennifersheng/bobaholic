//
//  Order+CoreDataProperties.swift
//  bobaholic
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var date: String?
    @NSManaged public var drink: Drink?

}

extension Order : Identifiable {

}
