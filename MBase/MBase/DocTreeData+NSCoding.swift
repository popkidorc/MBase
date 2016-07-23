//
//  DocTreeData+NSCoding.swift
//  MBase
//
//  Created by sunjie on 16/7/23.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocTreeData : NSCoding {
    
    func encodeWithCoder(coder: NSCoder){
        coder.encodeObject(self.id, forKey: "id");
        coder.encodeObject(self.name, forKey: "name");
        coder.encodeObject(self.number, forKey: "number");
        coder.encodeObject(self.image, forKey: "image");
        coder.encodeObject(self.level, forKey: "level");
        coder.encodeObject(self.parent, forKey: "parent");
        coder.encodeObject(self.isHasChild, forKey: "isHasChild");
        coder.encodeObject(self.children, forKey: "children");
    }

}