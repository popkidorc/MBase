//
//  DocEditViewController+Delegate.swift
//  MBase
//
//  Created by sunjie on 16/8/7.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocEditViewController: NSTextViewDelegate {
    
//    func textView(textView: NSTextView, clickedOnCell cell: NSTextAttachmentCellProtocol!, inRect cellFrame: NSRect) {
//        print("clickedOnCell")
//    }
    
//    func textView(textView: NSTextView, shouldChangeTextInRange affectedCharRange: NSRange, replacementString: String?) -> Bool {
//        print("shouldChangeTextInRange:"+replacementString!);
//        return true;
//    }
    
    func textDidChange(notification: NSNotification) {
        let oldString = textView.string!;
        let string = NSMutableAttributedString(string: oldString);
        let paragraph = NSMutableParagraphStyle();
        paragraph.alignment = NSTextAlignment.Justified;
        paragraph.firstLineHeadIndent = 20.0;
        paragraph.paragraphSpacingBefore = 10.0;
        paragraph.lineSpacing = 5;
        paragraph.hyphenationFactor = 1.0;
        string.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: NSMakeRange(0, string.length));
        textView.attributedString()
        docMainViewController.markdown = oldString;
        // 保存coredata
        self.docMainData.updateContent(oldString);
        
        docMainViewController.refreshContent();
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
        print("copyHtml:"+menuItem.title)
        menuItem
    }

}
