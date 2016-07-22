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
        
    }
    
    @IBAction func addChildTree(sender: AnyObject) {
        
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
        if selectedDocTree!.parent == nil || selectedDocTree!.parent?.number == -1 {
            parentDocTree = nil;
        }
        
        self.docTreeView.removeItemsAtIndexes(NSIndexSet(index: index!), inParent: parentDocTree, withAnimation: NSTableViewAnimationOptions.SlideLeft);
        
        
        // 4. 选中下一行并滚动到新行
        var newSelectedRow = index!;
        if(self.docTreeView.numberOfRows <= newSelectedRow){
            newSelectedRow = self.docTreeView.numberOfRows - 1;
        }
        self.docTreeView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
        self.docTreeView.scrollRowToVisible(newSelectedRow);
        
    }
    
}
