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
        print()
    }
    
    func textStorage(textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int){
    }
    
    func textDidChange(notification: NSNotification) {
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(changeTextFontNew), object: nil);
        
        self.performSelector(#selector(changeTextFontNew), withObject: nil, afterDelay: 0.2);
    }
    
    
    // 目标：尽量少的操作文档格式，过多操作会导致闪页和降速。
    func changeTextFontNew(){
        let start = CFAbsoluteTimeGetCurrent()
        
        // 全文
        let textString = self.docEditView.textStorage!.string;
        
        // 选择行
        let lineRange = NSUnionRange(self.docEditView.selectedRange(), NSString(string: textString).lineRangeForRange(NSMakeRange(NSMaxRange(self.docEditView.selectedRange()), 0)))
        // 上半段
        let preRange = NSMakeRange(0, lineRange.location);
        // 下半段
        let backRange = NSMakeRange(NSMaxRange(lineRange), NSString(string: textString).length - NSMaxRange(lineRange));
        
        // 获取最大范围的变更range
        let changeRange = self.getChangeRange(self.docEditView.textStorage!, lineRange: lineRange, preRange: preRange,  backRange: backRange);
        
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
    func getChangeRange(textStorage: NSTextStorage, lineRange: NSRange, preRange: NSRange,  backRange: NSRange) -> NSRange{
        let textString = NSString(string: textStorage.string);
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
                preCodeKeyRange = textStorage.string.rangeOfString(codeKey, exceptStrings: [MarkdownManager.MarkdownRegexParagraph.CODE1.codeKey], options: .BackwardsSearch , range: preRange);
                backCodeKeyRange = textStorage.string.rangeOfString(codeKey, exceptStrings: [MarkdownManager.MarkdownRegexParagraph.CODE1.codeKey], options: NSStringCompareOptions(rawValue: 0), range: backRange);
                preCount = textStorage.string.countOccurencesOfString(codeKey,exceptStrings: [MarkdownManager.MarkdownRegexParagraph.CODE1.codeKey], range: preRange);
            } else {
                preCodeKeyRange = textStorage.string.rangeOfString(codeKey, options: .BackwardsSearch , range: preRange);
                backCodeKeyRange = textStorage.string.rangeOfString(codeKey, options: NSStringCompareOptions(rawValue: 0), range: backRange);
                preCount = textStorage.string.countOccurencesOfString(codeKey, range: preRange);
            }
            // 处理关键字
            var changeRangeTemp: NSRange!;
            if preCount%2 == 0 {
                if backCodeKeyRange.length <= 0 {
                    // 选择行首到选择行尾
                    changeRangeTemp = lineRange;
                } else {
                    // 选择行行首到文章尾
                    changeRangeTemp = NSMakeRange(lineRange.location, textString.length - lineRange.location);
                }
            }else if preCount%2 == 1 {
                if backCodeKeyRange.length <= 0 {
                    // 上半段关键字到选择行行尾
                    changeRangeTemp = NSMakeRange(preCodeKeyRange.location, NSMaxRange(lineRange) - preCodeKeyRange.location);
                } else {
                    // 上半段关键字到文章尾
                    changeRangeTemp = NSMakeRange(preCodeKeyRange.location, textString.length - preCodeKeyRange.location);
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
