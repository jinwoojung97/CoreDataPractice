//
//  Contact+CoreDataProperties.swift
//  CoreDataPractice
//
//  Created by inforex on 2022/07/22.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var shortcutNumber: Int16
    @NSManaged public var habbit: [String]?

}

extension Contact : Identifiable {

}
