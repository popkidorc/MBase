//
//  DocEditViewController.swift
//  MBase
//
//  Created by sunjie on 16/8/3.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocEditViewController: NSViewController {

    
    @IBOutlet var textView: NSTextView!
    
    var docMainViewController: DocMainViewController!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docMainViewController.markdown = textView.string;
    }
    
}

extension DocEditViewController: NSTextViewDelegate {

    func textDidChange(notification: NSNotification) {
        docMainViewController.markdown = textView.string;
        print("textDidChange:"+textView.string!);
        docMainViewController.refreshContent();
    }
    
    
}