//
//  DocEditViewController.swift
//  MBase
//
//  Created by sunjie on 16/8/3.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import CoreData

class DocEditViewController: NSViewController,NSTextStorageDelegate {

    
    @IBOutlet var textView: DocEditTextView!
    
    var docEditView: NSTextView!
    
    var docEditTextStorage: DocEditTextStorage!;
    
    var docMainData: DocMain!;
    
    var docMainViewController: DocMainViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.textView.registerForDraggedTypes([NSPasteboardTypeString,NSPasteboardTypePNG]);
        self.textView.editable = false;
        self.textView.backgroundColor = NSColor(deviceRed: (244+1)/256, green: (244+1)/256, blue: (244+1)/256, alpha: 1);
        self.createDocEidtView();
    }
    
    func initDocEditDatas(docMainData: DocMain!){
        self.docMainData = docMainData;
        
        if DocMain.DocMainType.NotEdit.rawValue == docMainData.type {
            self.textView.editable = false;
            self.textView.backgroundColor = NSColor(deviceRed: (244+1)/256, green: (244+1)/256, blue: (244+1)/256, alpha: 1);
        }else{
            self.textView.editable = true;
            self.textView.backgroundColor = NSColor(deviceRed: (249+1)/256, green: (246+1)/256, blue: (236+1)/256, alpha: 1);
        }
        self.textView.string = docMainData.content!;
        docMainViewController.markdown = docMainData.content!;
        docMainViewController.refreshContent();
    }
    
    func createDocEidtView() {
        // 1. 初始化用于备份编辑器中文本的存储器
        let attrs = [NSFontAttributeName:NSFont.systemFontOfSize(14)];
        let attrString = NSAttributedString(string: "asdfas *dfa* sdf", attributes: attrs);
        self.docEditTextStorage = DocEditTextStorage();
        self.docEditTextStorage.appendAttributedString(attrString);
        
        let newTextViewRect = view.bounds
        
        // 2. 创建layoutManager
        let layoutManager = NSLayoutManager()
        
        // 3. 创建text container
        let containerSize = CGSize(width: newTextViewRect.width, height: CGFloat.max)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        
        
        // 4. 初始化并设置UITextView
        self.docEditView = NSTextView(frame: newTextViewRect, textContainer: container);
        self.docEditView.delegate = self
        layoutManager.addTextContainer(container)
        docEditTextStorage.addLayoutManager(layoutManager)
        docEditTextStorage.docEditView = self.docEditView;
        view.addSubview(self.docEditView)
    }
    
}