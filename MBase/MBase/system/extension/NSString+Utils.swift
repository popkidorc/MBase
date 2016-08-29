//
//  NSString+Utils.swift
//  MBase
//
//  Created by sunjie on 16/8/28.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension String {
    
    func rangeOfString(searchString: String, options: NSStringCompareOptions, range: NSRange) -> NSRange {
        return NSString(string: self).rangeOfString(searchString, options: options, range: range);
    }
    
    func rangeOfString(searchString: String, exceptStrings: [String], options: NSStringCompareOptions, range: NSRange) -> NSRange {
        if exceptStrings.count <= 0{
            return NSString(string: self).rangeOfString(searchString, options: options, range: range);
        }
        var stringTemp = NSString(string: self);
        for exceptString in exceptStrings {
            stringTemp = stringTemp.stringByReplacingOccurrencesOfString(exceptString, withString: "000", options: options, range: range)
        }
        return stringTemp.rangeOfString(searchString, options: options, range: range);
    }
    
    func isExistString(searchString: String) -> Bool {
        let range = self.rangeOfString(searchString);
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
    
    func countOccurencesOfString(searchString: String, exceptStrings: [String], range: NSRange) -> Int{
        let count1 = self.countOccurencesOfString(searchString, range: range);
        if count1 <= 0 {
            return 0;
        }
        var count2 = 0;
        for exceptString in exceptStrings {
            count2 += self.countOccurencesOfString(exceptString, range: range);
        }
        return count1 - count2;
    }

    
}
