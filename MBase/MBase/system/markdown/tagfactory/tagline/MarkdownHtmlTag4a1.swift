//
//  MarkdownHtmlTag4url1.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4a1: MarkdownHtmlTagLine {

    override init(range: NSRange){
        super.init(range: range);
        super.tagName = "a";
        super.markdownTag = ["[","]","(",")","<p>","</p>"];
    }
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        if string == ""{
            return super.getHtml(string, index: index, object: object);
        }
        var result = string;
        do{
            let regex = try NSRegularExpression(pattern: "(\\((.)*\\))", options: [.CaseInsensitive, .AnchorsMatchLines]);
            let textCheckingResult = regex.firstMatchInString(string, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count));
            if textCheckingResult != nil {
                let range = string.startIndex.advancedBy(textCheckingResult!.range.location+1)..<string.startIndex.advancedBy(textCheckingResult!.range.location+textCheckingResult!.range.length-1);
                super.tagValue["href"] = string.substringWithRange(range);
                result.removeRange(range);
            }
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        return super.getHtml(result, index: index, object: object);
    }
    
}
