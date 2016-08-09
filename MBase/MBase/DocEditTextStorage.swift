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
    
    var docEditView: NSTextView!
    
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
        let boldAttributes = [NSFontAttributeName : NSFont.boldSystemFontOfSize(14),NSForegroundColorAttributeName : NSColor.orangeColor()]
        //        var font = NSFontDescriptor(fontAttributes: [NSFontItalicTrait]);
        //
        let italicAttributes = [NSFontAttributeName : NSFont.systemFontOfSize(14), NSForegroundColorAttributeName : NSColor.orangeColor()];
        
        //            createAttributesForFontStyle(UIFontTextStyleBody, withTrait:.TraitItalic)
        let strikeThroughAttributes = [NSStrikethroughStyleAttributeName : 1]
        //        UIFont(descriptor: scriptFontDescriptor, size: CGFloat(bodyFontSize.floatValue))
        //            UIFontDescriptor(fontAttributes: [UIFontDescriptorFamilyAttribute : "Zapfino"])
        //        let scriptFontDescriptor = NSFontDescriptor(fontAttributes: [Nsfontdescriptor])
        //        NSFont(descriptor: <#T##NSFontDescriptor#>, textTransform: <#T##NSAffineTransform?#>)
        //        let scriptAttributes = [NSFontAttributeName : scriptFont]
        let redTextAttributes = [NSForegroundColorAttributeName : NSColor.redColor()]
        
        
        regexs = [
            "(\\*\\*\\w+(\\s\\w+)*\\*\\*)" : boldAttributes,
            "(\\*\\w+(\\s\\w+)*\\*)" : italicAttributes,
            "([0-9]+\\.)\\s" : boldAttributes,
            "(-\\w+(\\s\\w+)*-)" : strikeThroughAttributes,
            //            "(~\\w+(\\s\\w+)*~)" : scriptAttributes,
            "\\s([A-Z]{2,})\\s" : redTextAttributes
        ]
    }
    
    func applyStylesToRange(searchRange: NSRange) {
        let normalAttrs = [NSFontAttributeName : NSFont.systemFontOfSize(14)]
        
        // 遍历每个需要替换字体属性的文本
        for (pattern, attributes) in regexs {
            do{
                let regex = try NSRegularExpression(pattern: pattern, options:  NSRegularExpressionOptions.CaseInsensitive)
                regex.enumerateMatchesInString(backingStore.string, options: NSMatchingOptions(rawValue: 0), range: searchRange) {
                    match, flags, stop in
                    // 设置字体属性
                    let matchRange = match!.rangeAtIndex(1)
                    self.addAttributes(attributes, range: matchRange)
                    
                    // 还原字体样式
                    let maxRange = matchRange.location + matchRange.length
                    if maxRange + 1 < self.length {
                        self.addAttributes(normalAttrs, range: NSMakeRange(maxRange, 1))
                    }
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
