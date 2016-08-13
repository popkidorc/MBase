//
//  MarkdownHtmlTag4br.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4br: MarkdownHtmlTag {

    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "br";
        super.markdownTag = [""];
    }
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownManager.MarkdownRegex,[Dictionary<String, AnyObject>]>) -> String!{
        return self.tagL + self.tagEnd + self.tagName  + self.tagR;
    }

}
