//
//  MarkdownHtmlTag.swift
//  MBase
//
//  Created by sunjie on 16/8/11.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag: NSObject {

    var tagL = "<";
    
    var tagR = ">";
    
    var tagEnd = "/";
    
    var tagSpace = " ";
    
    var tagQuote = "\"";
    
    var tagEqual = "=";
    
    var tagName: String! = "";
    
    var markdownTag = [String]();
    
    var tagValue:Dictionary<String,String>!;
    
    var range: Range<String.CharacterView.Index>;
    
    init(range: Range<String.CharacterView.Index>) {
        self.range = range;
    }
    
    func getRange(offset: Int) -> Range<String.CharacterView.Index>{
        self.range.startIndex = self.range.startIndex.advancedBy(offset);
        self.range.endIndex = self.range.endIndex.advancedBy(offset);
        return self.range;
    }
        
    func getHtml( string: String, index: Int, object: Dictionary<MarkdownManager.MarkdownRegex,[Dictionary<String, AnyObject>]>) -> String!{
        var result = "";
        result += self.tagL + self.tagName;
        if tagValue != nil && tagValue.count > 0{
            for name in tagValue.keys {
                result += self.tagSpace + name  + self.tagEqual + self.tagQuote+tagValue[name]!+self.tagQuote;
            }
        }
        var str = string;
        for tag in self.markdownTag {
            str = str.stringByReplacingOccurrencesOfString(tag, withString: "")
        }
        result += self.tagR + str + self.tagL + self.tagEnd + self.tagName  + self.tagR;
        return result;
    }
    
    func getParamObejct(string: String) -> Dictionary<String, AnyObject>{
        return [:];
    }
}
