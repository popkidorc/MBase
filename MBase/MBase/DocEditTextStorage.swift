//
//  DocEditTextStorage.swift
//  MBase
//
//  Created by sunjie on 16/8/8.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocEditTextStorage: NSTextStorage {
    
    let backingStore = NSMutableAttributedString();
    
    var docEditView: DocEditTextView!
    
    //    var regexs: [String : [String : AnyObject]]!;
    
    override init() {
        super.init()
        //        initStyle();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(pasteboardPropertyList propertyList: AnyObject, ofType type: String) {
        super.init(pasteboardPropertyList: propertyList, ofType: type)
    }
    
    override var string: String {
        return backingStore.string
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return backingStore.attributesAtIndex(location, effectiveRange: range);
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        self.beginEditing()
        self.backingStore.replaceCharactersInRange(range, withString:str)
        self.edited([.EditedAttributes , .EditedCharacters], range: range, changeInLength: ((str as NSString).length - range.length))
        self.endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.EditedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    override func processEditing() {
        let newRange = NSRange(location: self.editedRange.location + self.editedRange.length, length: 0);
        self.performReplacementsForRange(self.editedRange)
        super.processEditing()
        //恢复光标位置
        if docEditView != nil {
            docEditView!.setSelectedRange(newRange);
        }
    }
    
    func applyStylesToRange(searchRange: NSRange) {
        if backingStore.string == ""
        {
            return;
        }
        let normalAttributes = [NSParagraphStyleAttributeName : ConstsManager.getDefaultParagraphStyle(), NSFontAttributeName : NSFont.systemFontOfSize(ConstsManager.defaultFontSize), NSForegroundColorAttributeName : ConstsManager.defaultFontColor];
        
        self.setAttributes(normalAttributes, range: searchRange);
        //正则匹配替换
        
        // 遍历每个需要替换字体属性的文本
        for tagRegex in MarkdownManager.MarkdownRegex.values {
            do{
                var regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.CaseInsensitive, .AnchorsMatchLines])
                if .P == tagRegex || .CODE == tagRegex {
                    regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.CaseInsensitive, .DotMatchesLineSeparators])
                }
                let textCheckingResults = regex.matchesInString(backingStore.string, options: NSMatchingOptions(rawValue: 0), range: searchRange);
                for textCheckingResult in textCheckingResults {
                    self.addAttributes(MarkdownEditFactory.getMarkdownAttributes(tagRegex), range: textCheckingResult.range)
                }
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
        }
    }
    
    func performReplacementsForRange(changedRange: NSRange) {
        //        let range = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(changedRange.location, 0)))
        //        let range = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(NSMaxRange(changedRange), 0)))
        let range = NSMakeRange(0, backingStore.string.characters.count);
        self.applyStylesToRange(range);
    }
}
