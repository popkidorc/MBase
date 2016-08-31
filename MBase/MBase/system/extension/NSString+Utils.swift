//
//  NSString+Utils.swift
//  MBase
//
//  Created by sunjie on 16/8/28.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension NSString {
    
    func rangeOfString(searchString: NSString, exceptStrings: [String], options: NSStringCompareOptions, range: NSRange) -> NSRange {
        if exceptStrings.count <= 0{
            return self.rangeOfString(searchString as String, options: options, range: range);
        }
        var stringTemp = NSString(string: self);
        for exceptString in exceptStrings {
            stringTemp = stringTemp.stringByReplacingOccurrencesOfString(exceptString, withString: "000", options: options, range: range)
        }
        return stringTemp.rangeOfString(searchString as String, options: options, range: range);
    }
    
    func isExistString(searchString: NSString) -> Bool {
        let range = self.rangeOfString(searchString as String);
        return range.length <= 0;
    }
    
    func isExistString(searchString: NSString, range: NSRange) -> Bool {
        let range = self.rangeOfString(searchString as String, options: NSStringCompareOptions(rawValue: 0), range: range);
        return range.length <= 0;
    }
    
    func countOccurencesOfString(searchString: NSString) -> Int {
        if searchString.length == 0{
            return 0;
        }
        let strCount = self.length - self.stringByReplacingOccurrencesOfString(searchString as String, withString: "").characters.count;
        return strCount / searchString.length;
    }
    
    func countOccurencesOfString(searchString: NSString, range: NSRange) -> Int{
        if searchString.length == 0{
            return 0;
        }
        let string = self.substringWithRange(range) as NSString;
        let strCount = string.length - string.stringByReplacingOccurrencesOfString(searchString as String
            , withString: "").characters.count;
        return strCount / searchString.length;
    }
    
    func countOccurencesOfString(searchString: NSString, exceptStrings: [String], range: NSRange) -> Int{
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
    
    //腐蚀制定ranges
    func corrodeString(ranges: [NSRange], corrodeRanges: [NSRange]) -> [NSRange]{
        //获取range坑集合
        var holeRanges = [NSRange]();
        ranges.count
        for index in 0 ..< ranges.count+1 {
            // 起点
            if index == 0 {
                holeRanges.append(NSMakeRange(0, 0));
                continue;
            }
            //终点
            else if index == ranges.count {
                holeRanges.append(NSMakeRange(ranges[0].location + NSMaxRange(ranges[ranges.count - 1]), 0));
                continue;
            }
            //中间点
            else {
                holeRanges.append(NSMakeRange(NSMaxRange(ranges[index-1]), ranges[index].location - NSMaxRange(ranges[index-1])))
            }
        }
        
        //组装holeRanges，追加corrodeRanges并重排序
        holeRanges.appendContentsOf(corrodeRanges);
        holeRanges = holeRanges.sort({ r1, r2 in r1.location < r2.location })
        
        //腐蚀corrodeRanges
        var corrodeResults = [NSRange]();
        for index in 0 ..< holeRanges.count {
            if index == 0 {
                continue;
            } else if holeRanges[index].location > NSMaxRange(holeRanges[index-1]){
                corrodeResults.append(NSMakeRange(NSMaxRange(holeRanges[index-1]), holeRanges[index].location - NSMaxRange(holeRanges[index-1])));
            }
        }
        return corrodeResults;
    }
    
}
