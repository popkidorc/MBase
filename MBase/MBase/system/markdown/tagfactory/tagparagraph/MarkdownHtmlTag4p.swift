//
//  MarkdownHtmlTag4p.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4p: MarkdownHtmlTag {
    
    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "p";
        super.markdownTag = ["\n\n"];
    }
    
    override func isHandler(string: String) ->Bool{
        if string == "" || string == "\n"{
            return false;
        }
        if string.hasPrefix("<h1") || string.hasPrefix("<h2") || string.hasPrefix("<h3") || string.hasPrefix("<h4") || string.hasPrefix("<h5") || string.hasPrefix("<h6") || string.hasPrefix("<hr"){
            return false;
        }
        return true;
    }
    
}
