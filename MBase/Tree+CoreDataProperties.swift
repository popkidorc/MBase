//
//  Tree+CoreDataProperties.swift
//  MBase
//
//  Created by sunjie on 16/7/24.
//  Copyright © 2016年 popkidorc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tree {

    @NSManaged var name: String?
    @NSManaged var content: String?
    @NSManaged var image: NSData?

}
