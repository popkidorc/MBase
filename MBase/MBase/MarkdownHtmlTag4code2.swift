//
//  MarkdownHtmlTag4code2.swift
//  MBase
//
//  Created by sunjie on 16/8/15.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4code2: MarkdownHtmlTag {

    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "code";
        super.markdownTag = ["`","</br>","<p>","</p>"];
    }
    
}
