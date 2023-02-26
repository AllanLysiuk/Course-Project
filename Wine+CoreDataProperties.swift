//
//  Wine+CoreDataProperties.swift
//  CourseProject
//
//  Created by Allan on 29.01.23.
//
//

import Foundation
import CoreData


extension Wine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wine> {
        return NSFetchRequest<Wine>(entityName: "Wine")
    }

    @NSManaged public var averageRating: Float
    @NSManaged public var id: Int32
    @NSManaged public var image: URL?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isSaved: Bool
    @NSManaged public var location: String?
    @NSManaged public var reviews: String?
    @NSManaged public var typeOfWine: String?
    @NSManaged public var wine: String?
    @NSManaged public var winery: String?

}

extension Wine : Identifiable {

}
