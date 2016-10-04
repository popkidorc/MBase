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
        //外层段落
        let sourceString = self.getOrderList(self.getNormalList(self.getP(string) as String) as String);
        var resultMap = Dictionary<Int, String>();
        
        var ranges = [NSRange]();
        var rangeTemps: [NSRange];
        
        
//        sourceString = self.getP(string);
        
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
        
        // 组合
        var result = "";
        for key in resultMap.keys.sort(<) {
            result += resultMap[key]!;
        }
        
        //增加资源
        if cssType != .None {
            result = "<html><head><script type='text/javascript' src='prettify.js')></script><link rel='stylesheet' type='text/css' href='prettify.css'><link rel='stylesheet' type='text/css' href='" + cssType.rawValue + ".css' ></head><body onload='prettyPrint()'>\n" + result + "</body></html>";
        }
        return result;
    }
    
    static func getP(string: String) -> NSString{
        //外层段落
        var result = NSString(string: "<p>" + string + "</p>");
        result = result.stringByReplacingOccurrencesOfString("\n", withString: "</p><p>");
        result = result.stringByReplacingOccurrencesOfString("((</p><p>){2,})", withString: "</p>\n<p>", options: [.RegularExpressionSearch], range: NSMakeRange(0, result.length ));
        result = result.stringByReplacingOccurrencesOfString("((</p><p>){1})", withString: "<br/>", options: [.RegularExpressionSearch], range: NSMakeRange(0, result.length));
        result = result.stringByReplacingOccurrencesOfString("<p></p>", withString: "");
        result = result.stringByReplacingOccurrencesOfString("<p><br/>", withString: "");
        return result;
    }
    
    static func getNormalList(string: String) -> NSString{
        var result = NSString(string: string);
        let pattern = "((<p>\\* )(.)*</p>)";
        var regex: NSRegularExpression?;
        do{
            regex = try NSRegularExpression(pattern: pattern, options: [.AnchorsMatchLines])
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        for textCheckingResult in regex!.matchesInString(result as String, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, result.length)){
            result.substringWithRange(textCheckingResult.range);
            var stringRange = textCheckingResult.range;
            let stringTemp1 = result.stringByReplacingOccurrencesOfString("<p>\\* ", withString: "<ul><li>", options: [.RegularExpressionSearch],range: stringRange)
            stringRange = NSMakeRange(stringRange.location, stringRange.length + stringTemp1.characters.count - result.length )
            let stringTemp2 = NSString(string: stringTemp1).stringByReplacingOccurrencesOfString("<br/>\\* ", withString: "</li><li>", options: [.RegularExpressionSearch],range: stringRange)
            stringRange = NSMakeRange(stringRange.location, stringRange.length + stringTemp2.characters.count - stringTemp1.characters.count  )
            result = NSString(string: stringTemp2).stringByReplacingOccurrencesOfString("</p>", withString: "</ul>", options: [.RegularExpressionSearch],range: stringRange)
        }
        return result;
    }
    
    static func getOrderList(string: String) -> NSString{
        var result = NSString(string: string);
        let pattern = "((<p>\\d{1,2}. )(.)*</p>)";
        var regex: NSRegularExpression?;
        do{
            regex = try NSRegularExpression(pattern: pattern, options: [.AnchorsMatchLines])
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        for textCheckingResult in regex!.matchesInString(result as String, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, result.length)){
            result.substringWithRange(textCheckingResult.range);
            var stringRange = textCheckingResult.range;
            let stringTemp1 = result.stringByReplacingOccurrencesOfString("<p>\\d{1,2}. ", withString: "<ol><li>", options: [.RegularExpressionSearch],range: stringRange)
            stringRange = NSMakeRange(stringRange.location, stringRange.length + stringTemp1.characters.count - result.length )
            let stringTemp2 = NSString(string: stringTemp1).stringByReplacingOccurrencesOfString("<br/>\\d{1,2}. ", withString: "</li><li>", options: [.RegularExpressionSearch],range: stringRange)
            stringRange = NSMakeRange(stringRange.location, stringRange.length + stringTemp2.characters.count - stringTemp1.characters.count  )
            result = NSString(string: stringTemp2).stringByReplacingOccurrencesOfString("</p>", withString: "</ol>", options: [.RegularExpressionSearch],range: stringRange)
        }
        return result;
    }
}
