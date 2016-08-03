//
//  Entity+CoreDataProperties.swift
//  coredataTest
//
//  Created by sunjie on 16/7/25.
//  Copyright © 2016年 popkidorc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Entity {

    @NSManaged var name: String?
    @NSManaged var number: NSNumber?

}
