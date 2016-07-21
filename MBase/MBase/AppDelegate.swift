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
        // Insert code here to initialize your application
        documentViewController = DocumentViewController(nibName: "DocumentViewController", bundle: nil);
        documentViewController.setupSampleBugs();
        
        let contentView = window.contentView!;
        contentView.addSubview(documentViewController.view);
        documentViewController.view.frame = contentView.bounds;
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

