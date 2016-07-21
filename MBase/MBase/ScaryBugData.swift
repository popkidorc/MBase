//
//  ScaryBugData.swift
//  MBase
//
//  Created by sunjie on 16/7/21.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class ScaryBugData: NSObject {
    
    var title: String;
    
    var rating: Double;
    
    override init() {
        self.title = String();
        self.rating = 0.0;
    }
    
    init(title: String, rating: Double) {
        self.title = title;
        self.rating = rating;
    }
}
