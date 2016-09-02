//
//  MarkdownHtmlTag4code.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4code1: MarkdownHtmlTagParagraph {

    override init(range: NSRange){
        super.init(range: range);
        super.tagName = "pre";
        super.tagValue = ["class":"defaultcode"];
        super.codeKey = "```";
    }
    
    override func getHtml4Prefix() -> String {
        return super.getHtml4Prefix() + "<code class='prettyprint defaultcode'>";
    }
    
    override func getHtml4Suffix() -> String {
        return  "</code>" + super.getHtml4Suffix();
    }
}
