//
//  MarkdownHtmlTag4url3.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4a3: MarkdownHtmlTag {
    
    override init(range: Range<String.CharacterView.Index>){
        super.init(range: range);
        super.tagName = "a";
        super.markdownTag = ["[","]"];
    }
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownManager.MarkdownRegex,[Dictionary<String, AnyObject>]>) -> String!{
        if string == ""{
            return super.getHtml(string, index: index, object: object);
        }
        var result = string;
        do{
            let a2Params = object[.A2]
            
            let regex = try NSRegularExpression(pattern: "(\\[\\d{1,2}\\]$)", options: [.CaseInsensitive, .AnchorsMatchLines]);
            let textCheckingResult = regex.firstMatchInString(string, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count));
            if textCheckingResult != nil {
                let range = string.startIndex.advancedBy(textCheckingResult!.range.location+1)..<string.startIndex.advancedBy(textCheckingResult!.range.location+textCheckingResult!.range.length-1);
                let numString = string.substringWithRange(range);
                if a2Params != nil{
                    for a2Param in a2Params! {
                        if let href = a2Param[numString] {
                            super.tagValue = ["href": href as! String];
                            result.removeRange(range);
                            break;
                        }
                    }
                }
            }
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        return super.getHtml(result, index: index, object: object);
    }
}
