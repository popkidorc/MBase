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
    
    static func generateHTMLForMarkdown(string: String, cssType: CssType  = .Default) -> NSString!{
        if string == "" {
            return "";
        }
        let sourceString = NSString(string: string);
        var resultMap = Dictionary<Int, String>();
        
        
        
        
        var ranges = [NSRange]();
        var rangeTemps: [NSRange];
        
        // 全局
        var objectDic = Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>();
        for tagRegex in MarkdownRegexCommonEnum.values {
            if ranges.count == 0 {
                ranges.append(NSMakeRange(0, sourceString.length));
            }
            var regex: NSRegularExpression?;
            do{
                regex =  try NSRegularExpression(pattern: tagRegex.rawValue, options: [.AnchorsMatchLines])
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
            rangeTemps = [NSRange]();
            for range in ranges {
                for textCheckingResult in regex!.matchesInString(sourceString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                    let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                    let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange);
                    if objectDic[tagRegex] == nil{
                        objectDic[tagRegex] = [markdownHtmlTag.getParamObejct(sourceString.substringWithRange(stringRange))];
                    }else {
                        objectDic[tagRegex]?.append(markdownHtmlTag.getParamObejct(sourceString.substringWithRange(stringRange)));
                    }
                    
                    rangeTemps.append(stringRange);
                }
            }
            // 腐蚀ranges
            ranges = CommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
        }
        
        // 段落
        for tagRegex in MarkdownRegexParagraphEnum.values {
            if ranges.count == 0 {
                ranges.append(NSMakeRange(0, sourceString.length));
            }
            var regex: NSRegularExpression?;
            do{
                regex =  try NSRegularExpression(pattern: tagRegex.rawValue, options: [.DotMatchesLineSeparators])
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
            rangeTemps = [NSRange]();
            var i = 1;
            for range in ranges {
                for textCheckingResult in regex!.matchesInString(sourceString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                    let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                    let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange);
                    resultMap[stringRange.location] = markdownHtmlTag.getHtml(sourceString.substringWithRange(stringRange), index:i, object: objectDic)
                    rangeTemps.append(stringRange);
                    i += 1;
                }
            }
            // 腐蚀ranges
            ranges = CommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
        }
        
        // 行
        for tagRegex in MarkdownRegexLineEnum.values {
            var regex: NSRegularExpression?;
            do{
                regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.AnchorsMatchLines])
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
            rangeTemps = [NSRange]();
            var i = 1;
            for range in ranges {
                for textCheckingResult in regex!.matchesInString(sourceString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                    let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                    let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange);
                    resultMap[stringRange.location] = markdownHtmlTag.getHtml(sourceString.substringWithRange(stringRange), index:i, object: objectDic)
                    rangeTemps.append(stringRange);
                    i += 1;
                }
            }
            // 腐蚀ranges
            ranges = CommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
        }
        
        // 剩余的，正常文本
        for range in ranges {
            resultMap[range.location] = sourceString.substringWithRange(range);
        }
        
        var result = "";
        
        for key in resultMap.keys.sort(<) {
            result += resultMap[key]!;
        }
       
        
        //替换转义
        //        result = self.handlerTransferString(result);
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
        
        
        //        result = result.stringByReplacingOccurrencesOfString("&lt;", withString: "<");
        //        result = result.stringByReplacingOccurrencesOfString("&gt;", withString: ">");
        //        result = result.stringByReplacingOccurrencesOfString("&quot;", withString: "\"");
        //        result = result.stringByReplacingOccurrencesOfString("&amp;", withString: "&");
        return result;
    }
}
