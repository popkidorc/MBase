//
//  MainWindowController.swift
//  MBase
//
//  Created by sunjie on 16/7/21.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    var documentViewController: DocumentViewController!;
    
    func initWindow(){
        self.contentViewController = NSViewController();
        self.contentViewController?.view = NSView();
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // 1. 创建documentViewController
        documentViewController = DocumentViewController(nibName: "DocumentViewController", bundle: nil);
        // 1.1 加载NSUserDefaults数据
        // documentViewController.setupSampleBugs();
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("bugs") as? NSData {
            documentViewController.bugs = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [ScaryBugDoc]
        } else {
            documentViewController.setupSampleBugs();
        }
        
        // 2. 添加view
        contentViewController!.view.addSubview(documentViewController.view);
        documentViewController.view.frame = contentViewController!.view.bounds;
        
        
        // 3. 设置masterViewController.view的布局约束
        documentViewController.view.translatesAutoresizingMaskIntoConstraints = false;
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
                                                                                 options: NSLayoutFormatOptions(rawValue: 0),
                                                                                 metrics: nil,
                                                                                 views: ["subView" : documentViewController.view]);
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
                                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                                   metrics: nil,
                                                                                   views: ["subView" : documentViewController.view]);
        NSLayoutConstraint.activateConstraints(verticalConstraints + horizontalConstraints);
    }
    
}
