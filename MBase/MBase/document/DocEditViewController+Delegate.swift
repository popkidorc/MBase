//
//  DocEditViewController+Delegate.swift
//  MBase
//
//  Created by sunjie on 16/8/7.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocEditViewController: NSTextViewDelegate, NSTextStorageDelegate {
    
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
        
        // 全文
        let textString = self.docEditView.textStorage!.string;
        
        // 选择行
        let lineRange = NSUnionRange(self.docEditView.selectedRange(), NSString(string: textString).lineRangeForRange(NSMakeRange(NSMaxRange(self.docEditView.selectedRange()), 0)))
        // 上半段
        let preRange = NSMakeRange(0, lineRange.location);
        // 下半段
        let backRange = NSMakeRange(NSMaxRange(lineRange), NSString(string: textString).length - NSMaxRange(lineRange));
        
        // 关键字
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
                preCodeKeyRange = textString.rangeOfString(codeKey, exceptStrings: [MarkdownManager.MarkdownRegexParagraph.CODE1.codeKey], options: .BackwardsSearch , range: preRange);
                backCodeKeyRange = textString.rangeOfString(codeKey, exceptStrings: [MarkdownManager.MarkdownRegexParagraph.CODE1.codeKey], options: NSStringCompareOptions(rawValue: 0), range: backRange);
                preCount = textString.countOccurencesOfString(codeKey,exceptStrings: [MarkdownManager.MarkdownRegexParagraph.CODE1.codeKey], range: preRange);
            } else {
                preCodeKeyRange = textString.rangeOfString(codeKey, options: .BackwardsSearch , range: preRange);
                backCodeKeyRange = textString.rangeOfString(codeKey, options: NSStringCompareOptions(rawValue: 0), range: backRange);
                preCount = textString.countOccurencesOfString(codeKey, range: preRange);
            }
            self.handlerChangeFont(tagRegex, textStorage: self.docEditView.textStorage!, preCount: preCount, lineRange: lineRange, preCodeKeyRange: preCodeKeyRange, backCodeKeyRange: backCodeKeyRange)
        }
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
        for tagRegex in MarkdownManager.MarkdownRegexParagraph.values  {
            if tagRegex == .P{
                continue;
            }
            self.applyStylesToRange4Paragraph(tagRegex, textStorage: textStorage, range: NSMakeRange(0,  self.docEditView!.string!.characters.count));
        }
    }
    
    func handlerChangeFont(paragraphRegex: MarkdownManager.MarkdownRegexParagraph, textStorage: NSTextStorage, preCount: Int, lineRange: NSRange, preCodeKeyRange: NSRange,  backCodeKeyRange: NSRange){
        let textString = NSString(string: textStorage.string);
        if preCount%2 == 0 {
            var codeRange: NSRange!;
            if backCodeKeyRange.length <= 0 {
                codeRange = lineRange;
                // 行
                self.applyStylesToRange4Line(textStorage, range: codeRange, isDefault: true);
            } else {
                // 选择行行首到文章尾
                codeRange = NSMakeRange(lineRange.location, textString.length - lineRange.location);
                // 行
                self.applyStylesToRange4Line(textStorage, range: codeRange, isDefault: true);
                // 段落
                self.applyStylesToRange4Paragraph(paragraphRegex, textStorage: textStorage, range: codeRange);
            }
        }else if preCount%2 == 1 {
            var codeRange: NSRange!;
            if backCodeKeyRange.length <= 0 {
                // 上半段关键字到选择行行尾
                codeRange = NSMakeRange(preCodeKeyRange.location, NSMaxRange(lineRange) - preCodeKeyRange.location);
            } else {
                // 上半段关键字到文章尾
                codeRange = NSMakeRange(preCodeKeyRange.location, textString.length - preCodeKeyRange.location);
            }
            // 行
            self.applyStylesToRange4Line(textStorage, range: codeRange, isDefault: true);
            // 段落
            self.applyStylesToRange4Paragraph(paragraphRegex, textStorage: textStorage, range: codeRange);
        }
    }
    
    func applyStylesToRange4Default(textStorage: NSTextStorage, range: NSRange){
        if textStorage.string == ""
        {
            return;
        }
        let normalAttributes = [NSParagraphStyleAttributeName : ConstsManager.getDefaultParagraphStyle(), NSFontAttributeName : NSFont.systemFontOfSize(ConstsManager.defaultFontSize), NSForegroundColorAttributeName : ConstsManager.defaultFontColor];
        textStorage.addAttributes(normalAttributes, range: range);
    }
    
    func applyStylesToRange4Paragraph(tagRegex: MarkdownManager.MarkdownRegexParagraph, textStorage: NSTextStorage, range: NSRange, isDefault: Bool = false){
        if textStorage.string == ""
        {
            return;
        }
        if isDefault {
            self.applyStylesToRange4Default(textStorage, range: range);
        }
        //段落
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
    
    func applyStylesToRange4Line(textStorage: NSTextStorage, range: NSRange, isDefault: Bool = false) {
        if textStorage.string == ""
        {
            return;
        }
        if isDefault {
            self.applyStylesToRange4Default(textStorage, range: range);
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
    
    func textView(view: NSTextView, menu: NSMenu, forEvent event: NSEvent, atIndex charIndex: Int) -> NSMenu? {
        print("menu:"+menu.title)
        for menuItem in menu.itemArray {
            if "字体" == menuItem.title{
                menuItem.hidden = true;
            }
        }
        //添加item
        let menuItem_copyHtml = NSMenuItem(title: "复制HTML", action: #selector(DocEditViewController.copyHtml), keyEquivalent: "");
        menu.insertItem(menuItem_copyHtml, atIndex: 0);
        
        return menu;
    }
    
    func copyHtml(menuItem: NSMenuItem) {
        let selectedText = self.docEditView.accessibilitySelectedText();
        if selectedText == ""{
            return;
        }
        let html = MarkdownManager.generateHTMLForMarkdown(selectedText!, cssType: .None);
        let pasteboard = NSPasteboard.generalPasteboard();
        pasteboard.clearContents();
        pasteboard.setString(html, forType: NSPasteboardTypeString);
    }
    
}
