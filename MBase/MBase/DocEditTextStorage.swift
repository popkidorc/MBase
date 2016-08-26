//
//  DocEditTextStorage.swift
//  MBase
//
//  Created by sunjie on 16/8/21.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocEditTextStorage: NSTextStorage {
    
    let backingStore = NSMutableAttributedString();
    
    var docEditView: NSTextView!
    
//    override init() {
//        super.init()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    required init?(pasteboardPropertyList propertyList: AnyObject, ofType type: String) {
//        super.init(pasteboardPropertyList: propertyList, ofType: type)
//    }
    
    override var string: String {
        return self.backingStore.string
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return self.backingStore.attributesAtIndex(location, effectiveRange: range);
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        self.beginEditing()
        self.backingStore.replaceCharactersInRange(range, withString:str)
        self.edited([.EditedAttributes , .EditedCharacters], range: range, changeInLength: ((str as NSString).length - range.length))
        self.endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        self.beginEditing()
        self.backingStore.setAttributes(attrs, range: range)
        self.edited(.EditedAttributes, range: range, changeInLength: 0)
        self.endEditing()
    }
    
    override func processEditing() {
        super.processEditing()

        self.performReplacementsForRange(self.editedRange)
    }
    
    func applyStylesToRange(searchRange: NSRange) {
//        if backingStore.string == ""
//        {
//            return;
//        }
//        let normalAttributes = [NSParagraphStyleAttributeName : ConstsManager.getDefaultParagraphStyle(), NSFontAttributeName : NSFont.systemFontOfSize(ConstsManager.defaultFontSize), NSForegroundColorAttributeName : ConstsManager.boldFontColor];
        
//        self.addAttributes([NSForegroundColorAttributeName : ConstsManager.boldFontColor], range: searchRange);
//                // 遍历每个需要替换字体属性的文本
//                for tagRegex in MarkdownManager.MarkdownRegex.values {
//                    do{
//                        let regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.CaseInsensitive, .AnchorsMatchLines])
//                        let textCheckingResults = regex.matchesInString(backingStore.string, options: NSMatchingOptions(rawValue: 0), range: searchRange);
//                        for textCheckingResult in textCheckingResults {
//                            self.addAttributes(MarkdownEditFactory.getMarkdownAttributes(tagRegex), range: textCheckingResult.range)
//                        }
//                    }catch{
//                        let nserror = error as NSError
//                        NSApplication.sharedApplication().presentError(nserror)
//                    }
//                }
    }
    
    func performReplacementsForRange(changedRange: NSRange) {
        var range = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(changedRange.location, 0)))
        range = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(NSMaxRange(changedRange), 0)))
        self.applyStylesToRange(range);
    }
}
