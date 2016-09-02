//
//  MarkdownHtmlTag4br.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4br: MarkdownHtmlTagLine {

    override init(range: NSRange){
        super.init(range: range);
        super.tagName = "br";
        super.markdownTag = ["\n"];
    }
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        return self.tagL + self.tagEnd + self.tagName  + self.tagR;
    }

}
