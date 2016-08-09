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
    
    var regexs: [String : [String : AnyObject]]!;
    
    override init() {
        super.init()
        initStyle();
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
    
    func initStyle(){
        let boldAttributes = [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.boldFontColor]
        let italicAttributes = [NSFontAttributeName : NSFont.systemFontOfSize(ConstsManager.defaultFontSize), NSForegroundColorAttributeName : ConstsManager.boldFontColor];
//        let strikeThroughAttributes = [NSStrikethroughStyleAttributeName : 1]
    
        let h1Attributes = [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("# ")];
        let h2Attributes = [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("## ")];
        let h3Attributes = [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("### ")];
        let h4Attributes = [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("#### ")];
        let h5Attributes = [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("##### ")];
        let h6Attributes = [NSFontAttributeName : NSFont.boldSystemFontOfSize(ConstsManager.defaultFontSize),NSForegroundColorAttributeName : ConstsManager.headerFontColor, NSParagraphStyleAttributeName: ConstsManager.getHeaderParagraphStyle("###### ")];
        
        regexs = [
            "(\\*\\*\\w+(\\s\\w+)*\\*\\*)" : boldAttributes,
            "(\\*\\w+(\\s\\w+)*\\*)" : italicAttributes,
            "([0-9]+\\.)\\s" : boldAttributes,
//            "(-\\w+(\\s\\w+)*-)" : strikeThroughAttributes,
            "(^\\# (.)*)" : h1Attributes,
            "(^\\#\\# (.)*)" : h2Attributes,
            "(^\\#\\#\\# (.)*)" : h3Attributes,
            "(^\\#\\#\\#\\# (.)*)" : h4Attributes,
            "(^\\#\\#\\#\\#\\# (.)*)" : h5Attributes,
            "(^\\#\\#\\#\\#\\#\\# (.)*)" : h6Attributes
            //            "(~\\w+(\\s\\w+)*~)" : scriptAttributes,
            //            "\\s([A-Z]{2,})\\s" : redTextAttributes
        ]
    }
    
    func applyStylesToRange(searchRange: NSRange) {
        let normalAttributes = [NSParagraphStyleAttributeName : ConstsManager.getDefaultParagraphStyle(), NSFontAttributeName : NSFont.systemFontOfSize(ConstsManager.defaultFontSize), NSForegroundColorAttributeName : ConstsManager.defaultFontColor];
        
        self.setAttributes(normalAttributes, range: searchRange);
        
        // 遍历每个需要替换字体属性的文本
        for (pattern, attributes) in regexs {
            do{
                let regex = try NSRegularExpression(pattern: pattern, options: [.CaseInsensitive, .AnchorsMatchLines])
                regex.enumerateMatchesInString(backingStore.string, options: NSMatchingOptions(rawValue: 0), range: searchRange) {
                    match, flags, stop in
                    // 设置字体属性
                    let matchRange = match!.rangeAtIndex(1)
                    self.addAttributes(attributes, range: matchRange)
                }
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
        }
    }
    
    func performReplacementsForRange(changedRange: NSRange) {
        var extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(changedRange.location, 0)))
        extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(NSMaxRange(changedRange), 0)))
        self.applyStylesToRange(extendedRange);
    }
}
