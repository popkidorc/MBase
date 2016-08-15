//
//  MarkdownManager.swift
//  MBase
//
//  Created by sunjie on 16/8/9.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownManager: NSObject {

    enum CssType : String {
        case None = "none"
        case Default = "default"
    }
    
    enum MarkdownRegex : String {
        
        static let values = [H1,H2,H3,H4,H5,H6,STRONG,EM,U,URL,A1,A2,IMG1,IMG2,HR,P,BR,CODE1,CODE2];
        
        case P = "(.*?\n)"
        case CODE1 = "(```(.)*?```)"
        case CODE2 = "(`(.)*?`)"
        
        case BR = "($)"
        case HR = "(^- - -$)"
        
        case H1 = "(^\\# (.)*)"
        case H2 = "(^\\#\\# (.)*)"
        case H3 = "(^\\#\\#\\# (.)*)"
        case H4 = "(^\\#\\#\\#\\# (.)*)"
        case H5 = "(^\\#\\#\\#\\#\\# (.)*)"
        case H6 = "(^\\#\\#\\#\\#\\#\\# (.)*)"
        case EM = "(\\*\\w+(\\s\\w+)*\\*)"
        case STRONG = "(\\*\\*\\w+(\\s\\w+)*\\*\\*)"
        case U = "(_\\w+(\\s\\w+)*_)"
        
        case URL = "(^\\[\\d{1,2}\\]:(.)*$)"

        
        case A1 = "(^\\[(.)*\\]\\((.)*\\)$)"
        case A2 = "(^\\[(.)*\\]\\[\\d{1,2}\\]$)"
        
        case IMG1 = "(^\\!\\[(.)*\\]\\((.)*\\)$)"
        case IMG2 = "(^\\!\\[(.)*\\]\\[\\d{1,2}\\]$)"
    }
    
    static func generateHTMLForMarkdown(string: String, cssType: CssType  = .Default) -> String!{
        if string == ""
        {
            return string;
        }
        var result = string;
        //正则匹配替换
        var objectDic = Dictionary<MarkdownRegex,[Dictionary<String, AnyObject>]>();
        // 遍历每个需要替换字体属性的文本
        for tagRegex in MarkdownRegex.values {
            do{
                var regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.CaseInsensitive, .AnchorsMatchLines]);
                if .P == tagRegex || .CODE1 == tagRegex  || .CODE2 == tagRegex{
                    regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.CaseInsensitive, .DotMatchesLineSeparators]);
                }
                let textCheckingResults = regex.matchesInString(result, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, result.characters.count));
                
                var markdownHtmlTagDictionary = Dictionary<Int, MarkdownHtmlTag>();
                var i = 1;
                for textCheckingResult in textCheckingResults {
                    let range = result.startIndex.advancedBy(textCheckingResult.range.location)..<result.startIndex.advancedBy(textCheckingResult.range.location+textCheckingResult.range.length);
                    
                    let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: range);
                    markdownHtmlTagDictionary[i] = markdownHtmlTag;
                    i += 1;
                }
                for index in markdownHtmlTagDictionary.keys.sort(>) {
                    let markdownHtmlTag = markdownHtmlTagDictionary[index];
                    let replaceString = result.substringWithRange(markdownHtmlTag!.range);
                    if !markdownHtmlTag!.isHandler(replaceString){
                        continue;
                    }
                    // 放入额外参数，和枚举顺序强相关
                    if objectDic[tagRegex] != nil{
                        objectDic[tagRegex]!.append(markdownHtmlTag!.getParamObejct(replaceString));
                    }else {
                        objectDic[tagRegex] = [markdownHtmlTag!.getParamObejct(replaceString)];
                    }
                    result.replaceRange(markdownHtmlTag!.range , with: markdownHtmlTag!.getHtml(replaceString, index:index, object: objectDic));
                }
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
        }
        //替换转义
        result = self.handlerTransferString(result);
        print(result);
        //增加资源
        if cssType != .None {
            result = "<html><head><script type='text/javascript' src='prettify.js')></script><link rel='stylesheet' type='text/css' href='prettify.css'><link rel='stylesheet' type='text/css' href='" + cssType.rawValue + ".css' ></head><body onload='prettyPrint()'>\n" + result + "</body></html>";
        }
        return result;
    }
    
    static private func handlerTransferString(string: String) -> String!{
        var result = string;
        result = result.stringByReplacingOccurrencesOfString("</p></br>", withString: "</p>");
        result = result.stringByReplacingOccurrencesOfString("</p><p>", withString: "");
        result = result.stringByReplacingOccurrencesOfString("</br>\n</br>", withString: "");
        result = result.stringByReplacingOccurrencesOfString("</br>\n</p>", withString: "</p>");
        result = result.stringByReplacingOccurrencesOfString("</pre></br>", withString: "</pre>");
        
        
        result = result.stringByReplacingOccurrencesOfString("&lt;", withString: "<");
        result = result.stringByReplacingOccurrencesOfString("&gt;", withString: ">");
        result = result.stringByReplacingOccurrencesOfString("&quot;", withString: "\"");
        result = result.stringByReplacingOccurrencesOfString("&amp;", withString: "&");
        return result;
    }
}
