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
    
    var mainWindowController : MainWindowController!;
    

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        mainWindowController = MainWindowController(windowNibName: "MainWindowController");
        mainWindowController.initWindow();
        
        if (!mainWindowController.window!.visible) {
            mainWindowController.showWindow(mainWindowController?.window);
        }
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // 1. 保存数据至NSUserDefaults
        //documentViewController.saveBugs();
    }
    
}

