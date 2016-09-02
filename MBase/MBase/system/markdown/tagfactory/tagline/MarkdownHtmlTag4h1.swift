//
//  MarkdownHtmlTag+h1.swift
//  MBase
//
//  Created by sunjie on 16/8/11.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4h1: MarkdownHtmlTagLine {
    
    override init(range: NSRange){
        super.init(range: range);
        super.tagName = "h1";
        super.markdownTag = ["# ","<p>","</p>"];
    }
    
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        super.tagValue["id"] = self.tagName + "id_" + String(index);
        return super.getHtml(string, index: index, object: object);
    }
}
