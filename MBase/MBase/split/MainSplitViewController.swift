//
//  MainSplitViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {
    
    var docTreeViewController: DocTreeViewController!;
    
    var docSplitViewController: DocSplitViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    var userInfo: UserInfo!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1 创建viewController
        docSplitViewController = DocSplitViewController(nibName: "DocSplitViewController", bundle: nil);
        docSplitViewController.splitView.delegate = docSplitViewController;
        
        let docSplitViewItem = NSSplitViewItem(viewController: docSplitViewController);
        self.addSplitViewItem(docSplitViewItem)

        docTreeViewController = DocTreeViewController(nibName: "DocTreeViewController", bundle: nil);
        docTreeViewController.docEditViewController = docSplitViewController.docEditViewController;
        docTreeViewController.managedObjectContext = self.managedObjectContext;
        docTreeViewController.userInfo = self.userInfo;
        docTreeViewController.initDocTreeDatas();
        
        
        //需要先加载docEditViewController
        let treeSplitViewItem = NSSplitViewItem(viewController: docTreeViewController);

        self.insertSplitViewItem(treeSplitViewItem, atIndex: 0);
        
        self.view.addConstraint(NSLayoutConstraint(
            item: treeSplitViewItem.viewController.view,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.GreaterThanOrEqual,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 0,
            constant: 250
            ))
        
        self.view.addConstraint(NSLayoutConstraint(
            item: docSplitViewItem.viewController.view,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.GreaterThanOrEqual,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 0,
            constant: 250
            ))
        
        docSplitViewItem.holdingPriority = 1.0 // has no effect

    }
    
}
