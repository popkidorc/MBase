//
//  MarkdownHtmlTag4img1.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4img1: MarkdownHtmlTag {

    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "img";
        super.markdownTag = ["!","[","]","(",")","<p>","</p>"];
    }
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownManager.MarkdownRegex,[Dictionary<String, AnyObject>]>) -> String!{
        if string == ""{
            return super.getHtml(string, index: index, object: object);
        }
        var result = string;
        do{
            let regex = try NSRegularExpression(pattern: "(\\((.)*\\))", options: [.CaseInsensitive, .AnchorsMatchLines]);
            let textCheckingResult = regex.firstMatchInString(string, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count));
            if textCheckingResult != nil {
                let range = string.startIndex.advancedBy(textCheckingResult!.range.location+1)..<string.startIndex.advancedBy(textCheckingResult!.range.location+textCheckingResult!.range.length-1);
                super.tagValue["src"] = string.substringWithRange(range);
                result.removeRange(range);
            }
            let regexAlt = try NSRegularExpression(pattern: "(^\\!\\[(.)*\\]\\(\\)$)", options: [.CaseInsensitive, .AnchorsMatchLines]);
            let textCheckingResultAlt = regexAlt.firstMatchInString(result, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, result.characters.count));
            if textCheckingResultAlt != nil {
                let range = result.startIndex.advancedBy(textCheckingResultAlt!.range.location+2)..<result.startIndex.advancedBy(textCheckingResultAlt!.range.location+textCheckingResultAlt!.range.length-3);
                super.tagValue["alt"] = result.substringWithRange(range);
                result.removeRange(range);
            }
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        return super.getHtml(result, index: index, object: object);
    }
    
}