//
//  MarkdownHtmlTag4url2.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4url: MarkdownHtmlTagCommon {
    
    override init(range: NSRange){
        super.init(range: range);
        super.tagName = "";
        super.markdownTag = [""];
    }
    
    override func getHtml(string: String, index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        return "";
    }
    
    override func getParamObejct(string: String) -> Dictionary<String, AnyObject>{
        let stringArr = string.componentsSeparatedByString("]:");
        let numString = stringArr[0].stringByReplacingOccurrencesOfString("[", withString: "");
        let hrefString = stringArr[1];
        return [numString: hrefString];
    }
}
