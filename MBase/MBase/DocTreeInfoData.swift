//
//  DocTreeInfoData.swift
//  MBase
//
//  Created by sunjie on 16/7/23.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocTreeInfoData: NSObject {
    
    var id: NSManagedObjectID!;
    
    var name: String!;
    
    var content: String!;
    
    var image: NSImage?;
    
    override init() {
        self.id = NSManagedObjectID();
        self.name = "";
        self.content = "";
        self.image = nil;
    }
    
    init(id: NSManagedObjectID!, name: String!,content: String!, image: NSImage?){
        self.id = id;
        self.name = name;
        self.content = content;
        self.image = image;
    }
    
}
