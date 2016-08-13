//
//  MarkdownHtmlTag4img2.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4img2: MarkdownHtmlTag {

    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "img";
        super.markdownTag = ["!","[","]"];
    }
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownManager.MarkdownRegex,[Dictionary<String, AnyObject>]>) -> String!{
        if string == ""{
            return super.getHtml(string, index: index, object: object);
        }
        var result = string;
        do{
            let urlParams = object[.URL]
            
            let regex = try NSRegularExpression(pattern: "(\\[\\d{1,2}\\]$)", options: [.CaseInsensitive, .AnchorsMatchLines]);
            let textCheckingResult = regex.firstMatchInString(string, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count));
            if textCheckingResult != nil {
                let range = string.startIndex.advancedBy(textCheckingResult!.range.location+1)..<string.startIndex.advancedBy(textCheckingResult!.range.location+textCheckingResult!.range.length-1);
                let numString = string.substringWithRange(range);
                if urlParams != nil{
                    for urlParam in urlParams! {
                        if let href = urlParam[numString] {
                            super.tagValue["src"] = href as? String;
                            result.removeRange(range);
                            break;
                        }
                    }
                }
            }
            let regexAlt = try NSRegularExpression(pattern: "(^\\!\\[(.)*\\]$)", options: [.CaseInsensitive, .AnchorsMatchLines]);
            let textCheckingResultAlt = regexAlt.firstMatchInString(string, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count));
            if textCheckingResultAlt != nil {
                let range = string.startIndex.advancedBy(textCheckingResultAlt!.range.location+2)..<string.startIndex.advancedBy(textCheckingResultAlt!.range.location+textCheckingResultAlt!.range.length-1);
                super.tagValue["alt"] = string.substringWithRange(range);
                result.removeRange(range);
            }
            
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        return super.getHtml(result, index: index, object: object);
    }
    
}