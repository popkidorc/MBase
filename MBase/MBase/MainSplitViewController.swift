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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1 创建viewController
        docTreeViewController = DocTreeViewController(nibName: "DocTreeViewController", bundle: nil);
        docTreeViewController.managedObjectContext = self.managedObjectContext;
        docTreeViewController.initDocTreeDatas();
        
        docMainViewController = DocMainViewController(nibName: "DocMainViewController", bundle: nil);
        
        docEditViewController = DocEditViewController(nibName: "DocEditViewController", bundle: nil);
        docEditViewController.docMainViewController = docMainViewController;
        docEditViewController.managedObjectContext = self.managedObjectContext;
        
        docTreeViewController.docEditViewController = docEditViewController;
        
        addSplitViewItem(NSSplitViewItem(viewController: docTreeViewController));
        addSplitViewItem(NSSplitViewItem(viewController: docEditViewController));
        addSplitViewItem(NSSplitViewItem(viewController: docMainViewController));
    }
    
}
