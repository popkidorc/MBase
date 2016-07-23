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
        // 1. 创建Tree
        let newDocTree = DocTreeData(id: 1, name: "new", image: NSImage(named: "centipedeThumb"), parent: selectedDocTree!.parent);
        
        // 2. 将该实例添加到父级Tree
        var parentDocTree = selectedDocTree!.parent;
        parentDocTree!.addChildTree(newDocTree);
        let index = parentDocTree!.children!.count - 1;
        
        // 3.向table view插入新行
        if parentDocTree == nil || parentDocTree!.number == -1 {
            parentDocTree = nil;
        }
        self.docTreeView.insertItemsAtIndexes(NSIndexSet(index: index), inParent: parentDocTree, withAnimation: NSTableViewAnimationOptions.EffectGap);
        
        // 4. 选中并滚动到新行
        let newSelectedRow = self.docTreeView.rowForItem(newDocTree);
        self.docTreeView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
        self.docTreeView.scrollRowToVisible(newSelectedRow);
    }
    
    @IBAction func addChildTree(sender: AnyObject) {
        var selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        // 1. 创建Tree
        let newDocTree = DocTreeData(id: 1, name: "new", image: NSImage(named: "centipedeThumb"), parent: selectedDocTree!);
        
        // 2. 将该实例添加到选中Tree
        selectedDocTree!.addChildTree(newDocTree);
        let index = selectedDocTree!.children!.count - 1;
        
        // 3.向table view插入新行
        if selectedDocTree!.number == -1 {
            selectedDocTree = nil;
        }
        self.docTreeView.insertItemsAtIndexes(NSIndexSet(index: index), inParent: selectedDocTree, withAnimation: NSTableViewAnimationOptions.EffectGap);
        
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
        
        // 3. 移除view
        var parentDocTree = selectedDocTree!.parent;
        if parentDocTree == nil || parentDocTree!.number == -1 {
            parentDocTree = nil;
        }
        self.docTreeView.removeItemsAtIndexes(NSIndexSet(index: index!), inParent: parentDocTree, withAnimation: NSTableViewAnimationOptions.SlideLeft);
    }
    
}
