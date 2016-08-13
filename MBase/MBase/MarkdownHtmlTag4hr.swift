//
//  MarkdownHtmlTag4separator.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4hr: MarkdownHtmlTag {
    
    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "hr";
        super.markdownTag = ["- - -"];
    }
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownManager.MarkdownRegex,[Dictionary<String, AnyObject>]>) -> String!{
        return self.tagL + self.tagName + self.tagEnd + self.tagR;
    }
}
