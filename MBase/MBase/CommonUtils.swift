//
//  CommonUtils.swift
//  MBase
//
//  Created by sunjie on 16/8/30.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class CommonUtils: NSObject {

    //获取两个NSRange的最大区间
    static func getMaxRange(range:NSRange, otherRange:NSRange) -> NSRange {
        let location = min(range.location, otherRange.location);
        let length = max(NSMaxRange(range), NSMaxRange(otherRange)) - location;
        return NSMakeRange(location, length);
    }
    
    
    static func isContainInCodeKey(string: NSString, codeKey: String, range: NSRange) -> Bool {
        // 上半段
        let preRange = NSMakeRange(0, range.location);
        let preCount = string.countOccurencesOfString(codeKey, range: preRange);
        if preCount%2 == 0 {
            return false;
        }
        // 下半段
        let backRange = NSMakeRange(range.location, string.length - range.location);
        if string.isExistString(codeKey, range: backRange) {
            return false;
        }
        return true;
    }
}
