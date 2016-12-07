//
//  MarkdownHtmlTagParagraph.swift
//  MBase
//
//  Created by sunjie on 16/9/2.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTagParagraph: MarkdownHtmlTag {

    override func getHtml( string: String, index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        var str = string;
        for tag in self.markdownTag {
            str = str.stringByReplacingOccurrencesOfString(tag, withString: "")
        }
        str = str.stringByReplacingOccurrencesOfString("<p>", withString: "")
        str = str.stringByReplacingOccurrencesOfString("</p>", withString: "")
        str = str.stringByReplacingOccurrencesOfString("<br/>", withString: "\n")
        return self.getHtml4Prefix() + self.handlerTransferString(str) + self.getHtml4Suffix()
    }
    
}
