//
//  MarkdownHtmlTag4italic.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4em: MarkdownHtmlTagLine {

    override init(range: NSRange, string: String){
        super.init(range: range, string: string);
        super.tagName = "em";
        super.markdownTag = ["*"];
    }

}
