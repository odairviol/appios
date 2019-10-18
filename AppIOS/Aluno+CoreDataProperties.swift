//
//  Aluno+CoreDataProperties.swift
//  AppIOS
//
//  Created by FBM on 18/10/19.
//  Copyright © 2019 pos. All rights reserved.
//
//

import Foundation
import CoreData


extension Aluno {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Aluno> {
        return NSFetchRequest<Aluno>(entityName: "Aluno")
    }

    @NSManaged public var dataNascimento: NSDate
    @NSManaged public var foto: NSData
    @NSManaged public var nome: String
    @NSManaged public var curso: Curso

}
