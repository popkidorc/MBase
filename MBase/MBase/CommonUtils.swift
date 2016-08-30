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
    static func getMaxRange(range:NSRange, otherRange:NSRange) -> NSRange{
        let location = min(range.location, otherRange.location);
        let length = max(NSMaxRange(range), NSMaxRange(otherRange)) - location;
        return NSMakeRange(location, length);
    }
    
}
