//
//  AppDelegate.swift
//  MBase
//
//  Created by sunjie on 16/7/21.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!;

    var documentViewController: DocumentViewController!;

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // 1. 创建documentViewController
        documentViewController = DocumentViewController(nibName: "DocumentViewController", bundle: nil);
        documentViewController.setupSampleBugs();
        
        // 2. 添加view
        let contentView = window.contentView!;
        contentView.addSubview(documentViewController.view);
        documentViewController.view.frame = contentView.bounds;
        
        
        // 3. 设置masterViewController.view的布局约束
        documentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
                                                                                 options: NSLayoutFormatOptions(rawValue: 0),
                                                                                 metrics: nil,
                                                                                 views: ["subView" : documentViewController.view]);
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
                                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                                   metrics: nil,
                                                                                   views: ["subView" : documentViewController.view]);
        NSLayoutConstraint.activateConstraints(verticalConstraints + horizontalConstraints)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

