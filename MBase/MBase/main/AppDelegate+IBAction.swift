//
//  AppDelegateIBAction.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

// MARK: - IBActions
extension AppDelegate {
    
    @IBAction func fileNew(sender: AnyObject) {
        if (!mainWindowController.window!.visible) {
            mainWindowController.showWindow(mainWindowController?.window);
        }
    }

}