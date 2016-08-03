//
//  MainWindowController.swift
//  MBase
//
//  Created by sunjie on 16/7/21.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    var mainSplitViewController: MainSplitViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    func initWindow(){
        self.contentViewController = NSViewController();
        self.contentViewController?.view = NSView(frame: NSRect(x: 0, y: 0, width: 512, height: 384));
    }
    
    override func windowDidLoad() {
        super.windowDidLoad();
        
        // 1. 创建viewController
        mainSplitViewController = MainSplitViewController(nibName: "MainSplitViewController", bundle: nil);
        mainSplitViewController.managedObjectContext = self.managedObjectContext;
        
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
    }
    
    func saveDatas(){
        //保存数据
        mainSplitViewController.saveDatas();
    }
    
}
