//
//  MarkdownHtmlTag4h3.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4h3: MarkdownHtmlTagLine {

    override init(range: NSRange){
        super.init(range: range);
        super.tagName = "h3";
        super.markdownTag = ["### "];
    }

}
