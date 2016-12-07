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
        // 1 创建viewController
        docMainViewController = DocMainViewController(nibName: "DocMainViewController", bundle: nil);
        docEditViewController = DocEditViewController(nibName: "DocEditViewController", bundle: nil);
        docEditViewController.docMainViewController = docMainViewController;
        docEditViewController.managedObjectContext = self.managedObjectContext;
        
        //需要先加载docEditViewController
        docEditSplitViewItem = NSSplitViewItem(viewController: docEditViewController);

        
        docEditSplitViewItem.minimumThickness = self.splitView.frame.width/2;
        docMainSplitViewItem = NSSplitViewItem(viewController: docMainViewController);
        docMainSplitViewItem.minimumThickness = self.splitView.frame.width/2;
        self.addSplitViewItem(docEditSplitViewItem);
        self.addSplitViewItem(docMainSplitViewItem);

        self.view.addConstraint(NSLayoutConstraint(
            item: docEditSplitViewItem.viewController.view,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.GreaterThanOrEqual,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 0,
            constant: 250
            ))
        
        self.view.addConstraint(NSLayoutConstraint(
            item: docMainSplitViewItem.viewController.view,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.GreaterThanOrEqual,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 0,
            constant: 250
            ))
        docEditSplitViewItem.holdingPriority = 1.0 // has no effect
        
    }
    
    override func splitView(splitView: NSSplitView, shouldHideDividerAtIndex dividerIndex: Int) -> Bool {
        return true;
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
