//
//  MarkdownHtmlTag4code.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4code1: MarkdownHtmlTag {

    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "pre";
        super.tagValue = ["class":"defaultcode"];
        super.markdownTag = ["```","</br>","<p>","</p>"];
    }
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownManager.MarkdownRegex,[Dictionary<String, AnyObject>]>) -> String!{
        var result = "";
        result += self.tagL + self.tagName;
        if tagValue.count > 0{
            for name in tagValue.keys {
                result += self.tagSpace + name  + self.tagEqual + self.tagQuote+tagValue[name]!+self.tagQuote;
            }
        }
        var str = string;
        for tag in self.markdownTag {
            str = str.stringByReplacingOccurrencesOfString(tag, withString: "")
        }
        result += self.tagR + "<code class='prettyprint defaultcode'>" + str + "</code>" + self.tagL + self.tagEnd + self.tagName  + self.tagR;
        return result;

    }
}
