//
//  DocEditViewController+Delegate.swift
//  MBase
//
//  Created by sunjie on 16/8/7.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocEditViewController: NSTextViewDelegate {
    
    func textDidChange(notification: NSNotification) {
       
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(changeTextFont), object: nil);
        
        self.performSelector(#selector(changeTextFont), withObject: nil, afterDelay: 0.2);
    }
    
    
    func changeTextFont(){
        let start = CFAbsoluteTimeGetCurrent()
        
        let range = self.docEditView.selectedRange();
        var extendedRange = NSUnionRange(range, NSString(string: self.docEditView.textStorage!.string).lineRangeForRange(NSMakeRange(range.location, 0)))
        extendedRange = NSUnionRange(range, NSString(string: self.docEditView.textStorage!.string).lineRangeForRange(NSMakeRange(NSMaxRange(range), 0)))
        self.applyStylesToRange(extendedRange);
        self.docMainViewController.markdown = self.docEditView.string!;
        // 保存coredata
        self.docMainData.updateContent(self.docEditView.string!);
        //        docMainViewController.refreshContent();

        print("applyStylesToRange:"+String(CFAbsoluteTimeGetCurrent()-start)+" seconds")
    }
    
    func applyStylesToRange(range: NSRange) {
        if self.docEditView.textStorage!.string == ""
        {
            return;
        }
        let normalAttributes = [NSParagraphStyleAttributeName : ConstsManager.getDefaultParagraphStyle(), NSFontAttributeName : NSFont.systemFontOfSize(ConstsManager.defaultFontSize), NSForegroundColorAttributeName : ConstsManager.defaultFontColor];
        self.docEditView.textStorage!.addAttributes(normalAttributes, range: range);
        
        //段落
        for tagRegex in MarkdownManager.MarkdownRegexParagraph.values {
            var regex: NSRegularExpression?;
            do{
                regex =  try NSRegularExpression(pattern: tagRegex.rawValue, options: [.CaseInsensitive, .DotMatchesLineSeparators])
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
            let textCheckingResults = regex!.matchesInString(self.docEditView.textStorage!.string, options: NSMatchingOptions(rawValue: 0), range: range);
            for textCheckingResult in textCheckingResults {
                let attrs = MarkdownEditFactory.getMarkdownAttributes(tagRegex);
                if attrs.count > 0  {
                    self.docEditView.textStorage!.addAttributes(attrs, range: textCheckingResult.range)
                }
            }
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
            
            let textCheckingResults = regex!.matchesInString(self.docEditView.textStorage!.string, options: NSMatchingOptions(rawValue: 0), range: range);
            for textCheckingResult in textCheckingResults {
                let attrs = MarkdownEditFactory.getMarkdownAttributes(tagRegex);
                if attrs.count > 0  {
                    self.docEditView.textStorage!.addAttributes(attrs, range: textCheckingResult.range)
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
