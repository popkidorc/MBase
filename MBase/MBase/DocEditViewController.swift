//
//  DocEditViewController.swift
//  MBase
//
//  Created by sunjie on 16/8/3.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import CoreData

class DocEditViewController: NSViewController {

    
    @IBOutlet var textView: NSTextView!
    
    var docMainData: DocMain!;
    
    var docMainViewController: DocMainViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.backgroundColor = NSColor(deviceRed: (249+1)/256, green: (246+1)/256, blue: (236+1)/256, alpha: 1);
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
    
}

extension DocEditViewController: NSTextViewDelegate {

    func textDidChange(notification: NSNotification) {
        docMainViewController.markdown = textView.string;
        // 保存coredata
        self.docMainData.updateContent(textView.string!);
        
        docMainViewController.refreshContent();
    }
    
}