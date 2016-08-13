//
//  MarkdownHtmlTag4bold.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4bold: MarkdownHtmlTag {

    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "font";
        super.tagValue["style"] = "font-weight: bold;";
        super.markdownTag = ["**"];
    }
    
}