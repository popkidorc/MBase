//
//  DocTreeInfoData.swift
//  MBase
//
//  Created by sunjie on 16/7/23.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocTreeInfoData: NSObject {
    
    var id: Int!;
    
    var name: String!;
    
    var content: String!;
    
    var image: NSImage?;
    
    override init() {
        self.id = 0;
        self.name = "";
        self.content = "";
        self.image = nil;
    }
    
    init(id: Int!, name: String!,content: String!, image: NSImage?){
        self.id = id;
        self.name = name;
        self.content = content;
        self.image = image;
    }
    
}
