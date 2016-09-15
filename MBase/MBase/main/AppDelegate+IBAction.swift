//
//  AppDelegateIBAction.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

// MARK: - IBActions
extension AppDelegate: NSMenuDelegate {

    
    func menuWillOpen(){
        print("====")
    }
    
    func menu(menu: NSMenu, updateItem item: NSMenuItem, atIndex index: Int, shouldCancel: Bool) -> Bool{
        print("====1===="+menu.title)
        return true
    }
    
    @IBAction func fileNew(sender: AnyObject) {
        if (!mainWindowController.window!.visible) {
            mainWindowController.showWindow(mainWindowController?.window);
        }
    }
    
    @IBAction func exportHtml(sender: AnyObject) {
        if self.mainWindowController.mainSplitViewController.docTreeViewController.selectedTree() == nil{
            return;
        }
        self.export("html");
    }
    
    @IBAction func exportText(sender: AnyObject) {
        if self.mainWindowController.mainSplitViewController.docTreeViewController.selectedTree() == nil{
            return;
        }
        self.export("text");
    }
    
    func export(type: String){
        let selectedTree = self.mainWindowController.mainSplitViewController.docTreeViewController.selectedTree()!;
        // 文章还是文件夹
        let panel = NSSavePanel();
        panel.canCreateDirectories = true;
        // 如果是文章
        if selectedTree.children!.count <= 0 {
            panel.nameFieldStringValue = selectedTree.name!;
            panel.allowedFileTypes = [type];
            panel.allowsOtherFileTypes = false;
            panel.extensionHidden = true;
        }
            // 如果是目录
        else {
            panel.nameFieldStringValue = "MBase文件";
            panel.allowsOtherFileTypes = false;
            panel.extensionHidden = true;
        }
        if panel.runModal() == NSFileHandlingPanelOKButton {
            let manager = NSFileManager.defaultManager();
            let path = panel.URL!.path!;
            do {
                if selectedTree.children!.count > 0{
                    // 先建目录
                    try manager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: [:]);
                }
                try ExportUtils.exportFiles(manager, docTree: selectedTree, exportPath: path, type: type);
            } catch{
                let nserror = error as NSError;
                NSApplication.sharedApplication().presentError(nserror);
            }
        }
    }
    
}