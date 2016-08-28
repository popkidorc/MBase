//
//  DocEditViewController+Delegate.swift
//  MBase
//
//  Created by sunjie on 16/8/7.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocEditViewController: NSTextViewDelegate, NSTextStorageDelegate {
    
    func textStorage(textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int){
        self.editedAttrString = textStorage.attributedSubstringFromRange(editedRange);
    }
    
    func textDidChange(notification: NSNotification) {
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(changeTextFont), object: nil);
        
        self.performSelector(#selector(changeTextFont), withObject: nil, afterDelay: 0.2);
    }
    
    
    func changeTextFont(){
        let start = CFAbsoluteTimeGetCurrent()
        
        let range = self.docEditView.selectedRange();
        let textString = NSString(string: self.docEditView.textStorage!.string);
        
        var extendedRange = NSUnionRange(range, textString.lineRangeForRange(NSMakeRange(range.location, 0)))
        extendedRange = NSUnionRange(range, textString.lineRangeForRange(NSMakeRange(NSMaxRange(range), 0)))
        
        let lineString = self.docEditView.textStorage!.attributedSubstringFromRange(extendedRange).string;
        let isEditCode  = lineString.isExistString(lineString);

        var preRange = NSMakeRange(0, range.location);
        var backRange = NSMakeRange(NSMaxRange(range), textString.length - NSMaxRange(range));
        // 如果当前行有`,则查找范围:向前=0到当前行首；向后=当前行尾到文章length
        if isEditCode {
            preRange = NSMakeRange(0, extendedRange.location);
            backRange = NSMakeRange(NSMaxRange(extendedRange), textString.length - NSMaxRange(extendedRange));
        }
        
        let count1 = self.docEditView.textStorage!.string.countOccurencesOfString("```", range: preRange);
        var preCode1Range: NSRange?;
        if count1%2 == 1 {
            preCode1Range = textString.rangeOfString("```", options: .BackwardsSearch , range: preRange, locale: nil);
        }
        
        let count2 = self.docEditView.textStorage!.string.countOccurencesOfString("```", range: backRange);
        var backCode1Range: NSRange?;
        if count2%2 == 1 {
            backCode1Range = textString.rangeOfString("```", options: NSStringCompareOptions(rawValue: 0), range: backRange, locale: nil);
        }
        
        //如果当前行有`,则先处理段落（＋默认）、然后处理行（－默认）
        // 1、向前有code=code起始点到当前行尾
        if isEditCode && preCode1Range != nil {
            let code1Range = NSMakeRange(preCode1Range!.location, NSMaxRange(extendedRange) - preCode1Range!.location);
            // 段落
            self.applyStylesToRange4Paragraph(self.docEditView.textStorage!, range: code1Range, isDefault: true);
            // 行
            self.applyStylesToRange4Line(self.docEditView.textStorage!, range: extendedRange, isDefault: false);
        }
        // 2、向后有code=当前行首到code结尾点
        else if isEditCode && backCode1Range != nil {
            let code1Range = NSMakeRange(extendedRange.location, NSMaxRange(backCode1Range!) - extendedRange.location);
            // 段落
            self.applyStylesToRange4Paragraph(self.docEditView.textStorage!, range: code1Range, isDefault: true);
            // 行
            self.applyStylesToRange4Line(self.docEditView.textStorage!, range: extendedRange, isDefault: false);
        }
        // 3、当前输入在code中、且当前行无`,则=code起始点到code结尾点
        else if preCode1Range != nil && backCode1Range  != nil {
            let code1Range = NSMakeRange(preCode1Range!.location, NSMaxRange(backCode1Range!) - preCode1Range!.location);
            // 段落
            self.applyStylesToRange4Paragraph(self.docEditView.textStorage!, range: code1Range, isDefault: true);
        } else {
            // 行
            self.applyStylesToRange4Line(self.docEditView.textStorage!, range: extendedRange, isDefault: true);
        }
        
        // 保存coredata
        self.docMainData.updateContent(self.docEditView.string!);
        
        self.docMainViewController.markdown = self.docEditView.string!;
        
//         docMainViewController.refreshContent();
        
        print("applyStylesToRange:"+String(CFAbsoluteTimeGetCurrent()-start)+" seconds")
    }
    
    
    func applyStylesToRange4Default(textStorage: NSTextStorage, range: NSRange){
        if textStorage.string == ""
        {
            return;
        }
        let normalAttributes = [NSParagraphStyleAttributeName : ConstsManager.getDefaultParagraphStyle(), NSFontAttributeName : NSFont.systemFontOfSize(ConstsManager.defaultFontSize), NSForegroundColorAttributeName : ConstsManager.defaultFontColor];
        textStorage.addAttributes(normalAttributes, range: range);
    }
    
    func applyStylesToRange4Paragraph(textStorage: NSTextStorage, range: NSRange, isDefault: Bool = false){
        if textStorage.string == ""
        {
            return;
        }
        if isDefault {
            self.applyStylesToRange4Default(textStorage, range: range);
        }
        //段落
        for tagRegex in MarkdownManager.MarkdownRegexParagraph.values {
            if tagRegex != .CODE1{
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
