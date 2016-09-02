//
//  MarkdownHtmlTag4p.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4p: MarkdownHtmlTagParagraph {
    
    override init(range: NSRange){
        super.init(range: range);
        super.tagName = "p";
        super.markdownTag = ["\n\n"];
    }
    
}
