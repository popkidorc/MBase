//
//  MarkdownHtmlTag+h1.swift
//  MBase
//
//  Created by sunjie on 16/8/11.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4h1: MarkdownHtmlTag {
    
    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "h1";
        super.markdownTag = ["# "];
    }
    
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownManager.MarkdownRegex,[Dictionary<String, AnyObject>]>) -> String!{
        super.tagValue = ["id": self.tagName+"id_" + String(index)];
        return super.getHtml(string, index: index, object: object);
    }
}
