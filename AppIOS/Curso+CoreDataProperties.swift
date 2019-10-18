//
//  Curso+CoreDataProperties.swift
//  AppIOS
//
//  Created by FBM on 18/10/19.
//  Copyright © 2019 pos. All rights reserved.
//
//

import Foundation
import CoreData


extension Curso {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Curso> {
        return NSFetchRequest<Curso>(entityName: "Curso")
    }

    @NSManaged public var ementa: String
    @NSManaged public var fim: NSDate
    @NSManaged public var inicio: NSDate
    @NSManaged public var nome: String

}
