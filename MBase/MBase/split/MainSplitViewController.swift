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
    
    var docEditViewController: DocEditViewController!;
    
    var docMainViewController: DocMainViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    var userInfo: UserInfo!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1 创建viewController
        docMainViewController = DocMainViewController(nibName: "DocMainViewController", bundle: nil);
        
        docEditViewController = DocEditViewController(nibName: "DocEditViewController", bundle: nil);
        docEditViewController.docMainViewController = docMainViewController;
        docEditViewController.managedObjectContext = self.managedObjectContext;

        docTreeViewController = DocTreeViewController(nibName: "DocTreeViewController", bundle: nil);
        docTreeViewController.docEditViewController = docEditViewController;
        docTreeViewController.managedObjectContext = self.managedObjectContext;
        docTreeViewController.userInfo = self.userInfo;
        docTreeViewController.initDocTreeDatas();
        
        self.addSplitViewItem(NSSplitViewItem(viewController: docEditViewController));
        self.addSplitViewItem(NSSplitViewItem(viewController: docMainViewController));
        //需要先加载docEditViewController
        self.insertSplitViewItem(NSSplitViewItem(viewController: docTreeViewController), atIndex: 0);
    }
    
}
