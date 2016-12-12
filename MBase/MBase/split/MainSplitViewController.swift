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
        let allWidth = self.parentViewController!.view.frame.size.width;
        let allHeight = self.parentViewController!.view.frame.size.height;
        
        docSplitViewController = DocSplitViewController(nibName: "DocSplitViewController", bundle: nil);
        docSplitViewController.view.frame = NSMakeRect(0, 0, allWidth * ConstsManager.docSplitViewWidthRatio, allHeight);

        let docSplitViewItem = NSSplitViewItem(viewController: docSplitViewController);
        self.addSplitViewItem(docSplitViewItem)

        docTreeViewController = DocTreeViewController(nibName: "DocTreeViewController", bundle: nil);
        docTreeViewController.docEditViewController = docSplitViewController.docEditViewController;
        docTreeViewController.managedObjectContext = self.managedObjectContext;
        docTreeViewController.userInfo = self.userInfo;
        docTreeViewController.initDocTreeDatas();
        docTreeViewController.view.frame = NSMakeRect(0, 0, allWidth - docSplitViewController.view.frame.width, allHeight);
        
        //需要先加载docEditViewController
        let treeSplitViewItem = NSSplitViewItem(viewController: docTreeViewController);

        self.insertSplitViewItem(treeSplitViewItem, atIndex: 0);

    }
    
    override func splitViewDidResizeSubviews(notification: NSNotification) {
        let allWidth = self.parentViewController!.view.frame.size.width * ConstsManager.docSplitViewWidthRatio;
        let allHeight = self.parentViewController!.view.frame.size.height;
        print("==allHeight=="+String(allHeight)+"===="+String(self.docSplitViewController.docEditViewController.view.frame.height));
        if self.docSplitViewController.docEditViewController.view.frame.width != allWidth/2 ||
            self.docSplitViewController.docEditViewController.view.frame.height != allHeight{
            print("==allHeight 2=="+String(self.docSplitViewController.docEditViewController.docEditView.frame.height));

            self.docSplitViewController.docEditViewController.view.frame = NSMakeRect(0, 0, allWidth / 2, allHeight);
            self.docSplitViewController.docEditViewController.docEditView.frame = NSMakeRect(0, 0, allWidth / 2, allHeight);
        }
        if self.docSplitViewController.docMainViewController.view.frame.width != allWidth/2 ||
            self.docSplitViewController.docMainViewController.view.frame.height != allHeight{
            self.docSplitViewController.docMainViewController.view.frame = NSMakeRect(allWidth / 2, 0, allWidth / 2, allHeight);
        }
    }
    
}
