//
//  MarkdownHtmlTag4h2.swift
//  MBase
//
//  Created by sunjie on 16/8/11.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4h2: MarkdownHtmlTag {

    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "h2";
        super.markdownTag = ["## "];
    }
    
}
