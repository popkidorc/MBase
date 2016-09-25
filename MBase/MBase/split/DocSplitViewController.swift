//
//  DocSplitViewController.swift
//  MBase
//
//  Created by sunjie on 16/9/25.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocSplitViewController: NSSplitViewController {

    var docEditViewController: DocEditViewController!;
    
    var docMainViewController: DocMainViewController!;
    
    var docEditSplitViewItem: NSSplitViewItem!;
    
    var docMainSplitViewItem: NSSplitViewItem!;

    var managedObjectContext: NSManagedObjectContext!;
    
    var userInfo: UserInfo!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // 1 创建viewController
        docMainViewController = DocMainViewController(nibName: "DocMainViewController", bundle: nil);
        
        docEditViewController = DocEditViewController(nibName: "DocEditViewController", bundle: nil);
        docEditViewController.docMainViewController = docMainViewController;
        docEditViewController.managedObjectContext = self.managedObjectContext;
        print("===="+String(self.splitView.frame.width)+"==="+String(self.splitView.frame.height))
        
        //需要先加载docEditViewController
        docEditSplitViewItem = NSSplitViewItem(viewController: docEditViewController);
//        docEditSplitViewItem.maximumThickness = self.splitView.frame.width/2;
        docEditSplitViewItem.minimumThickness = self.splitView.frame.width/2;
//        docEditSplitViewItem.automaticMaximumThickness = self.splitView.frame.width/2;
        docMainSplitViewItem = NSSplitViewItem(viewController: docMainViewController);
//        docMainSplitViewItem.maximumThickness = self.splitView.frame.width/2;
        docMainSplitViewItem.minimumThickness = self.splitView.frame.width/2;
//        docMainSplitViewItem.automaticMaximumThickness = self.splitView.frame.width/2;
//        docMainSplitViewItem.collapsed = true;
        self.addSplitViewItem(docEditSplitViewItem);
        self.addSplitViewItem(docMainSplitViewItem);

    }
    
    
    func hideDocEditSplitView(){
        if self.splitViewItems.contains(docEditSplitViewItem) {
            self.removeSplitViewItem(docEditSplitViewItem);
        }
    }
    
    func hideDocMainSplitView(){
        if self.splitViewItems.contains(docMainSplitViewItem) {
            self.removeSplitViewItem(docMainSplitViewItem);
        }
    }
    
    func showDocEditSplitView(){
        if !self.splitViewItems.contains(docEditSplitViewItem) {
            self.insertSplitViewItem(docEditSplitViewItem, atIndex: 0);
        }
    }
    
    func showDocMainSplitView(){
        if !self.splitViewItems.contains(docMainSplitViewItem) {
            self.addSplitViewItem(docMainSplitViewItem);
        }
    }
    
}
