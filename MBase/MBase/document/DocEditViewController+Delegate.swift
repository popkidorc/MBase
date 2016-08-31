//
//  DocEditViewController+Delegate.swift
//  MBase
//
//  Created by sunjie on 16/8/7.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocEditViewController: NSTextStorageDelegate {
    
    func textStorage(textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
    }
    
    func textStorage(textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int){
    }
    
    func textDidChange(notification: NSNotification) {
        
//        print("===="+String(self.docEditView.textStorage!.paragraphs.count));
//        for storage in self.docEditView.textStorage!.paragraphs {
//            print("==1=="+storage.string);
//        }
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(changeTextFontNew), object: nil);
        
        self.performSelector(#selector(changeTextFontNew2), withObject: nil, afterDelay: 0.2);
    }
    
    
    //腐蚀算法
    func changeTextFontNew2(){
        let start = CFAbsoluteTimeGetCurrent()
        
        // 全文
        let textString = NSString(string: self.docEditView.textStorage!.string);
        
        // 选择行
        let lineRange = NSUnionRange(self.docEditView.selectedRange(), textString.lineRangeForRange(NSMakeRange(NSMaxRange(self.docEditView.selectedRange()), 0)))
        // 上半段
        let preRange = NSMakeRange(0, lineRange.location);
        // 下半段
        let backRange = NSMakeRange(NSMaxRange(lineRange), textString.length - NSMaxRange(lineRange));

        // 段落
        var ranges = [NSRange]();
        var rangeTemps: [NSRange];
        var stringTemp: String;
        for tagRegex in MarkdownManager.MarkdownRegexParagraph.values {
            if tagRegex.rawValue == "" || tagRegex.codeKey == "" {
                continue;
            }
            if ranges.count == 0 {
                let changeRange = self.getChangeRangeNew2(tagRegex, string: textString, lineRange: lineRange, preRange: preRange, backRange: backRange);
                ranges.append(changeRange);
                // 默认
                self.applyStylesToRange4Default(self.docEditView.textStorage!, range: changeRange);
            }
            var regex: NSRegularExpression?;
            do{
                regex =  try NSRegularExpression(pattern: tagRegex.rawValue, options: [.CaseInsensitive, .DotMatchesLineSeparators])
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
            rangeTemps = [NSRange]();
            let start1 = CFAbsoluteTimeGetCurrent()
            for range in ranges {
                stringTemp = textString.substringWithRange(range);
                for textCheckingResult in regex!.matchesInString(stringTemp, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                    let start2 = CFAbsoluteTimeGetCurrent()
                    let attrs = MarkdownEditFactory.getMarkdownAttributes(tagRegex);
                    if attrs.count > 0  {
                        let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                        self.docEditView.textStorage!.addAttributes(attrs, range: stringRange);
                        rangeTemps.append(stringRange);
                        print("============"+String(CFAbsoluteTimeGetCurrent()-start2)+" seconds, range:"+String(range.location)+", "+String(range.length)+", rangeTemps:"+String(stringRange.location)+", "+String(stringRange.length));
                    }
                }
            }
            // 腐蚀ranges
            ranges = CommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
            print("========"+String(CFAbsoluteTimeGetCurrent()-start1)+" seconds")
        }
        
        // 保存coredata
        self.docMainData.updateContent(self.docEditView.string!);
        
        self.docMainViewController.markdown = self.docEditView.string!;
        
        //         docMainViewController.refreshContent();
        
        print("applyStylesToRange:"+String(CFAbsoluteTimeGetCurrent()-start)+" seconds")
    }
    
    // 目标：尽量少的操作文档格式，过多操作会导致闪页和降速。
    func changeTextFontNew(){
        let start = CFAbsoluteTimeGetCurrent()
        
        // 全文
        let textString = NSString(string: self.docEditView.textStorage!.string);
        
        // 选择行
        let lineRange = NSUnionRange(self.docEditView.selectedRange(), textString.lineRangeForRange(NSMakeRange(NSMaxRange(self.docEditView.selectedRange()), 0)))
        // 上半段
        let preRange = NSMakeRange(0, lineRange.location);
        // 下半段
        let backRange = NSMakeRange(NSMaxRange(lineRange), textString.length - NSMaxRange(lineRange));
        
        // 获取最大范围的变更range
        let changeRange = self.getChangeRange(textString, lineRange: lineRange, preRange: preRange,  backRange: backRange);
        
        // 默认
        self.applyStylesToRange4Default(self.docEditView.textStorage!, range: changeRange);
        // 行
        self.applyStylesToRange4Line(self.docEditView.textStorage!, range: changeRange);
        // 段落
        self.applyStylesToRange4Paragraph(self.docEditView.textStorage!, range: changeRange);
        // 放入缓存
        
        // 保存coredata
        self.docMainData.updateContent(self.docEditView.string!);
        
        self.docMainViewController.markdown = self.docEditView.string!;
        
        //         docMainViewController.refreshContent();
        
        print("applyStylesToRange:"+String(CFAbsoluteTimeGetCurrent()-start)+" seconds")
    }
    
    func handlerInitFont(textStorage: NSTextStorage){
        // 默认
        self.applyStylesToRange4Default(textStorage, range: NSMakeRange(0, self.docEditView!.string!.characters.count));
        // 行
        self.applyStylesToRange4Line(textStorage, range: NSMakeRange(0,  self.docEditView!.string!.characters.count));
        // 段落
        self.applyStylesToRange4Paragraph(textStorage, range: NSMakeRange(0,  self.docEditView!.string!.characters.count));
    }
    
    
    func getChangeRangeNew2(tagRegex : MarkdownManager.MarkdownRegexParagraph, string: NSString, lineRange: NSRange, preRange: NSRange,  backRange: NSRange) -> NSRange{
        let codeKey = tagRegex.codeKey;
        // 上半段最近的段关键字
        let preCodeKeyRange = string.rangeOfString(codeKey, options: .BackwardsSearch , range: preRange);
        // 下半段最近的段关键字
        let backCodeKeyRange = string.rangeOfString(codeKey, options: NSStringCompareOptions(rawValue: 0), range: backRange);
        // 上半段，段关键字出现次数
        let preCount = string.countOccurencesOfString(codeKey, range: preRange);
        // 处理关键字
        var changeRangeTemp: NSRange!;
        if preCount%2 == 0 {
            if backCodeKeyRange.length <= 0 {
                // 选择行首到选择行尾
                changeRangeTemp = lineRange;
            } else {
                // 选择行行首到文章尾
                changeRangeTemp = NSMakeRange(lineRange.location, NSString(string: string).length - lineRange.location);
            }
        } else if preCount%2 == 1 {
            if backCodeKeyRange.length <= 0 {
                // 上半段关键字到选择行行尾
                changeRangeTemp = NSMakeRange(preCodeKeyRange.location, NSMaxRange(lineRange) - preCodeKeyRange.location);
            } else {
                // 上半段关键字到文章尾
                changeRangeTemp = NSMakeRange(preCodeKeyRange.location, NSString(string: string).length - preCodeKeyRange.location);
            }
        }
        return changeRangeTemp;
    }
    
    
    // 获取段与段间，以```为例。思路：按选择行将文章分为两份，上半份倒查段的关键字；下半份正查段的关键字。
    /** 对于上半段:
     1. 如果出现了偶数个相同关键字，则说明selectedRange不在对应code中，这时需要判断下半段：
     1.1 如果下半段没有关键字，则处理单行；
     1.2 如果下半段有关键字，则处理选择行行首到文章尾；
     2. 如果出现了奇数个相同关键字，则说明选择行在对应code中，，这时需要判断下半段：
     2.1 如果下半段没有关键字，则处理上半段关键字到选择行行尾；
     2.2 如果下半段有关键字，则处理上半段关键字到文章尾；
     **/
    /** 对于下半段:
     配合上半段处理。
     **/
    func getChangeRange(string: NSString, lineRange: NSRange, preRange: NSRange,  backRange: NSRange) -> NSRange{
        var changeRange: NSRange!;
        for tagRegex in MarkdownManager.MarkdownRegexParagraph.values  {
            if tagRegex == .P{
                continue;
            }
            let codeKey = tagRegex.codeKey;
            // 上半段最近的段关键字
            var preCodeKeyRange: NSRange!;
            // 下半段最近的段关键字
            let backCodeKeyRange: NSRange!;
            // 上半段，段关键字出现次数
            var preCount: Int!;
            if tagRegex == .CODE2 {
                preCodeKeyRange = string.rangeOfString(codeKey, exceptStrings: [MarkdownManager.MarkdownRegexParagraph.CODE1.codeKey], options: .BackwardsSearch , range: preRange);
                backCodeKeyRange = string.rangeOfString(codeKey, exceptStrings: [MarkdownManager.MarkdownRegexParagraph.CODE1.codeKey], options: NSStringCompareOptions(rawValue: 0), range: backRange);
                preCount = string.countOccurencesOfString(codeKey,exceptStrings: [MarkdownManager.MarkdownRegexParagraph.CODE1.codeKey], range: preRange);
            } else {
                preCodeKeyRange = string.rangeOfString(codeKey, options: .BackwardsSearch , range: preRange);
                backCodeKeyRange = string.rangeOfString(codeKey, options: NSStringCompareOptions(rawValue: 0), range: backRange);
                preCount = string.countOccurencesOfString(codeKey, range: preRange);
            }
            // 处理关键字
            var changeRangeTemp: NSRange!;
            if preCount%2 == 0 {
                if backCodeKeyRange.length <= 0 {
                    // 选择行首到选择行尾
                    changeRangeTemp = lineRange;
                } else {
                    // 选择行行首到文章尾
                    changeRangeTemp = NSMakeRange(lineRange.location, NSString(string: string).length - lineRange.location);
                }
            }else if preCount%2 == 1 {
                if backCodeKeyRange.length <= 0 {
                    // 上半段关键字到选择行行尾
                    changeRangeTemp = NSMakeRange(preCodeKeyRange.location, NSMaxRange(lineRange) - preCodeKeyRange.location);
                } else {
                    // 上半段关键字到文章尾
                    changeRangeTemp = NSMakeRange(preCodeKeyRange.location, NSString(string: string).length - preCodeKeyRange.location);
                }
            }
            // 取最大范围
            if changeRange == nil {
                changeRange = changeRangeTemp;
            } else {
                changeRange = CommonUtils.getMaxRange(changeRange, otherRange: changeRangeTemp);
            }
        }
        return changeRange;
    }
    
    func applyStylesToRange4Default(textStorage: NSTextStorage, range: NSRange){
        if textStorage.string == ""
        {
            return;
        }
        let normalAttributes = [NSParagraphStyleAttributeName : ConstsManager.getDefaultParagraphStyle(), NSFontAttributeName : NSFont.systemFontOfSize(ConstsManager.defaultFontSize), NSForegroundColorAttributeName : ConstsManager.defaultFontColor];
        textStorage.addAttributes(normalAttributes, range: range);
    }
    
    func applyStylesToRange4Paragraph(textStorage: NSTextStorage, range: NSRange){
        if textStorage.string == ""
        {
            return;
        }
        //段落
        for tagRegex in MarkdownManager.MarkdownRegexParagraph.values {
            if tagRegex == .P {
                continue;
            }
            var regex: NSRegularExpression?;
            do{
                regex =  try NSRegularExpression(pattern: tagRegex.rawValue, options: [.CaseInsensitive, .DotMatchesLineSeparators])
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
            let textCheckingResults = regex!.matchesInString(textStorage.string, options: NSMatchingOptions(rawValue: 0), range: range);
            for textCheckingResult in textCheckingResults {
                let attrs = MarkdownEditFactory.getMarkdownAttributes(tagRegex);
                if attrs.count > 0  {
                    //如果code2，需要判断是否在code1中
                    if tagRegex == .CODE2 && CommonUtils.isContainInCodeKey(NSString(string: textStorage.string), codeKey: MarkdownManager.MarkdownRegexParagraph.CODE1.codeKey, range: textCheckingResult.range){
                        continue;
                    }
                    textStorage.addAttributes(attrs, range: textCheckingResult.range)
                }
            }
        }
    }
    
    func applyStylesToRange4Line(textStorage: NSTextStorage, range: NSRange) {
        if textStorage.string == ""
        {
            return;
        }
        // 遍历每个需要替换字体属性的文本
        for tagRegex in MarkdownManager.MarkdownRegex.values {
            var regex: NSRegularExpression?;
            do{
                regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.CaseInsensitive, .AnchorsMatchLines])
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
            
            let textCheckingResults = regex!.matchesInString(textStorage.string, options: NSMatchingOptions(rawValue: 0), range: range);
            for textCheckingResult in textCheckingResults {
                let attrs = MarkdownEditFactory.getMarkdownAttributes(tagRegex);
                if attrs.count > 0  {
                    textStorage.addAttributes(attrs, range: textCheckingResult.range)
                }
            }
        }
    }
    
}
