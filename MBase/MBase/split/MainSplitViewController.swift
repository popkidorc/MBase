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
    
//        // 1 创建viewController
//        docMainViewController = DocMainViewController(nibName: "DocMainViewController", bundle: nil);
//        
//        docEditViewController = DocEditViewController(nibName: "DocEditViewController", bundle: nil);
//        docEditViewController.docMainViewController = docMainViewController;
//        docEditViewController.managedObjectContext = self.managedObjectContext;
        
        docSplitViewController = DocSplitViewController(nibName: "DocSplitViewController", bundle: nil);
        
        
        let docSplitViewItem = NSSplitViewItem(viewController: docSplitViewController);
        self.addSplitViewItem(docSplitViewItem)
        // http://www.jianshu.com/p/4b1b7c75836d
        //http://blog.csdn.net/koupoo/article/details/6755991
        
//        let viewController = MainViewController(nibName: "MainViewController", bundle: nil)!;
//        
//        
//        viewController.addChildViewController(docEditViewController);
//        viewController.addChildViewController(docMainViewController);
//        
//        viewController.view.addSubview(docEditViewController.view);
//        viewController.view.addSubview(docMainViewController.view);
        
        docTreeViewController = DocTreeViewController(nibName: "DocTreeViewController", bundle: nil);
        docTreeViewController.docEditViewController = docSplitViewController.docEditViewController;
        docTreeViewController.managedObjectContext = self.managedObjectContext;
        docTreeViewController.userInfo = self.userInfo;
        docTreeViewController.initDocTreeDatas();
        
//        //需要先加载docEditViewController
//        let docEditSplitViewItem = NSSplitViewItem(viewController: docEditViewController);
//        docEditSplitViewItem.maximumThickness = 100;
//        docEditSplitViewItem.minimumThickness = 100;
//        let docMainSplitViewItem = NSSplitViewItem(viewController: docMainViewController);
//        docMainSplitViewItem.maximumThickness = 100;
//        docMainSplitViewItem.minimumThickness = 100;
//        self.addSplitViewItem(docEditSplitViewItem);
//        self.addSplitViewItem(docMainSplitViewItem);
        
//        self.addSplitViewItem(NSSplitViewItem(viewController: viewController))
        let treeSplitViewItem = NSSplitViewItem(viewController: docTreeViewController);
        treeSplitViewItem.preferredThicknessFraction = self.splitView.frame.width/4;
//        treeSplitViewItem.maximumThickness = self.splitView.frame.width/4;
        treeSplitViewItem.minimumThickness = self.splitView.frame.width/4;
//        treeSplitViewItem.automaticMaximumThickness = self.splitView.frame.width/4;
        
        self.insertSplitViewItem(treeSplitViewItem, atIndex: 0);
    }
    

//    override func splitView(splitView: NSSplitView, resizeSubviewsWithOldSize oldSize: NSSize) {
//        
//        
//        let dividerThickness = splitView.dividerThickness;
//        
//        
//        var leftRect = splitView.subviews[1].frame;
//        var rightRect = splitView.subviews[2].frame;
//
//        let newFrame = splitView.frame;
//        
//        leftRect.size.height = newFrame.size.height;
//        leftRect.origin = NSMakePoint(0, 0);
//        rightRect.size.width = newFrame.size.width - leftRect.size.width - dividerThickness;
//        rightRect.size.height = newFrame.size.height;
//        rightRect.origin.x = leftRect.size.width + dividerThickness;
//        
//        
//        splitView.subviews[1].frame =
//        leftRect
//        splitView.subviews[2].frame = rightRect
//        //        NSRect leftRect = [[[sender subviews] objectAtIndex:0] frame];
////        NSRect rightRect = [[[sender subviews] objectAtIndex:1] frame];
////        NSRect newFrame = [sender frame];
////        
////        leftRect.size.height = newFrame.size.height;
////        leftRect.origin = NSMakePoint(0, 0);
////        rightRect.size.width = newFrame.size.width - leftRect.size.width
////            - dividerThickness;
////        rightRect.size.height = newFrame.size.height;
////        rightRect.origin.x = leftRect.size.width + dividerThickness;
//        
////        [[[sender subviews] objectAtIndex:0] setFrame:leftRect];
////        [[[sender subviews] objectAtIndex:1] setFrame:rightRect];
//    }
}
