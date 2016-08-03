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
    
    var docMainViewController: DocMainViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1 创建viewController
        docTreeViewController = DocTreeViewController(nibName: "DocTreeViewController", bundle: nil);
        docTreeViewController.managedObjectContext = self.managedObjectContext;
        
        // 1.1 加载数据
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("docTree") as? NSData {
            docTreeViewController.docTreeData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! DocTreeData;
        } else {
            docTreeViewController.initDocTreeDatas();
        }
        
        docMainViewController = DocMainViewController(nibName: "DocMainViewController", bundle: nil);
        
        
        addSplitViewItem(NSSplitViewItem(viewController: docTreeViewController));
        addSplitViewItem(NSSplitViewItem(viewController: docMainViewController));
    }
    
    func saveDatas(){
        // 保存tree数据
        docTreeViewController.saveDatas();
    }
}
