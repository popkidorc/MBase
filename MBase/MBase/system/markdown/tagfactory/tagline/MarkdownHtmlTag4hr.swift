//
//  MarkdownHtmlTag4separator.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4hr: MarkdownHtmlTagLine {
    
    override init(range: NSRange){
        super.init(range: range);
        super.tagName = "hr";
        super.markdownTag = ["- - -","<p>","</p>"];
    }
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        return self.tagL + self.tagName + self.tagEnd + self.tagR;
    }
}
