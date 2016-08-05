//
//  DocTreeViewController+MenuIBAction.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocTreeViewController {
    
    @IBAction func addTree(sender: AnyObject) {
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        let parentDocTree = managedObjectContext.objectWithID(selectedDocTree!.parent!.objectID) as! DocTree;
        // 1. 创建Tree
        let newDocTree = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        let newDocMain = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
        newDocMain.initData("", summary: "", mark: "", type: DocMain.DocMainType.Markdown, docTree: newDocTree);
        newDocTree.initData("new",content: "", image: NSImage(named: "centipedeThumb"), type: DocTree.DocTreeType.Normal,  parent: parentDocTree, docMain: newDocMain);
        
        // 2. 将该实例添加到父级Tree
        parentDocTree.addChildTree(newDocTree);
        let index = parentDocTree.children!.count - 1;
        
        // 3.向table view插入新行
        if parentDocTree.number == -1 {
            self.docTreeView.insertItemsAtIndexes(NSIndexSet(index: index), inParent: nil, withAnimation: NSTableViewAnimationOptions.EffectGap);
        }else{
            self.docTreeView.insertItemsAtIndexes(NSIndexSet(index: index), inParent: parentDocTree, withAnimation: NSTableViewAnimationOptions.EffectGap);
        }
        
        // 4. 选中并滚动到新行
        let newSelectedRow = self.docTreeView.rowForItem(newDocTree);
        self.docTreeView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
        self.docTreeView.scrollRowToVisible(newSelectedRow);
    }
    
    @IBAction func addChildTree(sender: AnyObject) {
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        // 1. 创建Tree
        let newDocTree = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        let newDocMain = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
        newDocMain.initData("", summary: "", mark: "", type: DocMain.DocMainType.Markdown, docTree: newDocTree);
        newDocTree.initData("new", content: "", image: NSImage(named: "centipedeThumb"), type: DocTree.DocTreeType.Normal,  parent: selectedDocTree!, docMain: newDocMain);
        
        // 2. 将该实例添加到选中Tree
        selectedDocTree!.addChildTree(newDocTree);
        let index = selectedDocTree!.children!.count - 1;
        
        // 3.向table view插入新行
        if selectedDocTree!.number == -1 {
            self.docTreeView.insertItemsAtIndexes(NSIndexSet(index: index), inParent: nil, withAnimation: NSTableViewAnimationOptions.EffectGap);
        }else{
            self.docTreeView.insertItemsAtIndexes(NSIndexSet(index: index), inParent: selectedDocTree, withAnimation: NSTableViewAnimationOptions.EffectGap);
        }
        
        
        // 4. 展开选中节点
        self.docTreeView.expandItem(selectedDocTree);
        
        // 5. 选中并滚动到新行
        let newSelectedRow = self.docTreeView.rowForItem(newDocTree);
        self.docTreeView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
        self.docTreeView.scrollRowToVisible(newSelectedRow);
    }
    
    @IBAction func removeTree(sender: AnyObject) {
        // 1. 获取选中tree
        let selectedDocTree = self.selectedTree();
        if (selectedDocTree == nil) {
            return;
        }
        let index = selectedDocTree!.getIndex();
        if index == nil {
            return;
        }
        // 2. model中移除数据,以及对应文档数据
        selectedDocTree!.remove();
        
        // 2.1. 删除coredata中数据
        self.managedObjectContext.deleteObject(selectedDocTree!);
        
        // 3. 移除view
        var parentDocTree = selectedDocTree!.parent;
        if parentDocTree == nil || parentDocTree!.number == -1 {
            parentDocTree = nil;
        }
        self.docTreeView.removeItemsAtIndexes(NSIndexSet(index: index!), inParent: parentDocTree, withAnimation: NSTableViewAnimationOptions.SlideLeft);
    }
    
}
