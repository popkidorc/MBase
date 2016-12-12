//
//  DocSplitViewController.swift
//  MBase
//
//  Created by sunjie on 16/9/25.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocSplitViewController: NSViewController {

    var docEditViewController: DocEditViewController!;

    var docMainViewController: DocMainViewController!;

    var managedObjectContext: NSManagedObjectContext!;
    
    var userInfo: UserInfo!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        docMainViewController = DocMainViewController(nibName: "DocMainViewController", bundle: nil);
        
        docEditViewController = DocEditViewController(nibName: "DocEditViewController", bundle: nil);

        docEditViewController.docMainViewController = docMainViewController;
        docEditViewController.managedObjectContext = self.managedObjectContext;
     
        self.addChildViewController(docEditViewController);
        self.view.addSubview(docEditViewController.view);

        self.addChildViewController(docMainViewController);
        self.view.addSubview(docMainViewController.view);
        
    }
    
}
