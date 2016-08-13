//
//  MarkdownHtmlTag4italic.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4italic: MarkdownHtmlTag {

    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "font";
        super.tagValue["style"] = "font-style:italic;";
        super.markdownTag = ["*"];
    }

}
