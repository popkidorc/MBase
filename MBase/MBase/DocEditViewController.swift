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
    }
    
    func initDocEditDatas(docMainData: DocMain!){
        self.docMainData = docMainData;
        
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