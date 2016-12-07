//
//  DocEditViewController+Delegate.swift
//  MBase
//
//  Created by sunjie on 16/8/7.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import MBaseMarkdown

extension DocEditViewController: NSTextStorageDelegate {
    
    func textStorage(textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
    }
    
    func textStorage(textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int){
        if editedMask != .EditedAttributes {
            self.editedRange = editedRange;
        }
    }
    
    func textDidChange(notification: NSNotification) {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(changeTextFont), object: nil);
        self.performSelector(#selector(changeTextFont), withObject: nil, afterDelay: 0.3);
    }

    func changeTextFont(){
        
        let markdownEditManager = MarkdownEditManager(textStorage: self.docEditView.textStorage!);
        
        let content =  markdownEditManager.changeTextFont(self.docEditView.selectedRange(), editedRange: self.editedRange!);
        
        // 保存coredata
        self.docMainData.updateContent(content);
        
        self.docMainViewController.markdown = content;
        
        NSNotificationCenter.defaultCenter().postNotificationName("refreshContent", object: nil);
        
        NSNotificationCenter.defaultCenter().postNotificationName("changeDocImage", object: nil);
    }
    
    func handlerInitFont(){
        let markdownEditManager = MarkdownEditManager(textStorage: self.docEditView.textStorage!);
        
        markdownEditManager.handlerInitFont();
    }
    
}
