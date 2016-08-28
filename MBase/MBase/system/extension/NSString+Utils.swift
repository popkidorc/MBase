//
//  NSString+Utils.swift
//  MBase
//
//  Created by sunjie on 16/8/28.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension String {
    
    func isExistString(searchString: String) -> Bool {
        let range = self.rangeOfString("`");
        return range != nil;
    }

    func countOccurencesOfString(searchString: String) -> Int {
        let strCount = self.characters.count - self.stringByReplacingOccurrencesOfString(searchString, withString: "").characters.count;
        return strCount / searchString.characters.count;
    }
    
    func countOccurencesOfString(searchString: String, range: NSRange) -> Int{
        let string = NSString(string: self).substringWithRange(range);
        let strCount = string.characters.count - string.stringByReplacingOccurrencesOfString(searchString, withString: "").characters.count;
        return strCount / searchString.characters.count;
    }

    
}
