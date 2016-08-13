//
//  MarkdownEditFactory.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownEditFactory: MarkdownHtmlTag {

    static func getMarkdownAttributes(tagRegex: MarkdownManager.MarkdownRegex) -> [String : AnyObject]{
        
        switch tagRegex {
        case .P:
            return [:];
        case .CODE:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.codeFontColor];
        case .URL:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.codeFontColor];
        case .A1:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.codeFontColor];
        case .A2:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.codeFontColor];
        case .IMG1:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.codeFontColor];
        case .IMG2:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.codeFontColor];
        case .BR:
            return [:];
        case .HR:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.codeFontColor];
        case .H1:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("# ")];
        case .H2:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("## ")];
        case .H3:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("### ")];
        case .H4:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("#### ")];
        case .H5:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("##### ")];
        case .H6:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("###### ")];
        case .STRONG:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.boldFontColor]
        case .EM:
            return [NSFontAttributeName : NSFont.systemFontOfSize(ConstsManager.defaultFontSize), NSForegroundColorAttributeName : ConstsManager.boldFontColor];
        case .U:
            return [NSFontAttributeName : NSFont.systemFontOfSize(ConstsManager.defaultFontSize), NSForegroundColorAttributeName : ConstsManager.boldFontColor];

            //        let strikeThroughAttributes = [NSStrikethroughStyleAttributeName : 1]
        }
    }

}
