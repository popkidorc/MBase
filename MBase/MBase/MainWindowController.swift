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
    
    var mainSplitViewController: MainSplitViewController!;
    
    func initWindow(){
        self.contentViewController = NSViewController();
        self.contentViewController?.view = NSView(frame: NSRect(x: 0, y: 0, width: 512, height: 384));
    }
    
    override func windowDidLoad() {
        super.windowDidLoad();
        
        // 1. 创建viewController
        mainSplitViewController = MainSplitViewController(nibName: "MainSplitViewController", bundle: nil);
        
        // 2. 添加view
        contentViewController!.view.addSubview(mainSplitViewController.view);
        mainSplitViewController.view.frame = contentViewController!.view.bounds;
        
        // 3. 设置masterViewController.view的布局约束
        mainSplitViewController.view.translatesAutoresizingMaskIntoConstraints = false;
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
                                                                                 options: NSLayoutFormatOptions(rawValue: 0),
                                                                                 metrics: nil,
                                                                                 views: ["subView" : mainSplitViewController.view]);
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
                                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                                   metrics: nil,
                                                                                   views: ["subView" : mainSplitViewController.view]);
        NSLayoutConstraint.activateConstraints(verticalConstraints + horizontalConstraints);
        
        //        // 1. 创建documentViewController
        //        documentViewController = DocumentViewController(nibName: "DocumentViewController", bundle: nil);
        //        // 1.1 加载NSUserDefaults数据
        //        // documentViewController.setupSampleBugs();
        //        if let data = NSUserDefaults.standardUserDefaults().objectForKey("bugs") as? NSData {
        //            documentViewController.bugs = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [ScaryBugDoc]
        //        } else {
        //            documentViewController.setupSampleBugs();
        //        }
        //
        //        // 2. 添加view
        //        contentViewController!.view.addSubview(documentViewController.view);
        //        documentViewController.view.frame = contentViewController!.view.bounds;
        //
        //
        //        // 3. 设置masterViewController.view的布局约束
        //        documentViewController.view.translatesAutoresizingMaskIntoConstraints = false;
        //        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
        //                                                                                 options: NSLayoutFormatOptions(rawValue: 0),
        //                                                                                 metrics: nil,
        //                                                                                 views: ["subView" : documentViewController.view]);
        //        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
        //                                                                                   options: NSLayoutFormatOptions(rawValue: 0),
        //                                                                                   metrics: nil,
        //                                                                                   views: ["subView" : documentViewController.view]);
        //        NSLayoutConstraint.activateConstraints(verticalConstraints + horizontalConstraints);
    }
    
}
