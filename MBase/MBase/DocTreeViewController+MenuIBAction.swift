//
//  DocTreeViewController+MenuIBAction.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocTreeViewController: NSMenuDelegate {
    
    func menuWillOpen(menu: NSMenu) {
        print("menuWillOpen");
        let selectedDocTree = self.selectedTree();
        for menuItem in menu.itemArray {
            if selectedDocTree == nil {
                menuItem.hidden = true;
                continue;
            }
            if DocTree.DocTreeType.Trash.rawValue == selectedDocTree?.type {
                if "清空回收站" == menuItem.title {
                    menuItem.hidden = false;
                    continue;
                } else {
                    menuItem.hidden = true;
                    continue;
                }
            }
            
            if DocTree.DocTreeType.Trash.rawValue != selectedDocTree?.type {
                if "清空回收站" == menuItem.title {
                    menuItem.hidden = true;
                    continue;
                } else {
                    menuItem.hidden = false;
                    continue;
                }
            }
            menuItem.hidden = false;
        }
    }
    
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
        
        // 3. 重载
        self.docTreeView.reloadData();
        
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
        
        // 3. 重载
        self.docTreeView.reloadData();

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
        // 2. 移动到回收站
        var trashTree: DocTree?;
        for docTree in docTreeData.children! {
            if DocTree.DocTreeType.Trash.rawValue == (docTree as! DocTree).type {
                trashTree = docTree as? DocTree;
            }
        }
        if trashTree == nil {
            return;
        }
        self.moveNode(selectedDocTree!, targetParentDocTree: trashTree!, targetIndex: nil);
        
        // 3. 重载
        self.docTreeView.reloadData();
    }
    
    @IBAction func cleanTrash(sender: AnyObject) {
        // 1. 获取选中tree
        let selectedDocTree = self.selectedTree();
        if (selectedDocTree == nil) {
            return;
        }

        // 2. model中移除数据,以及对应文档数据
        if selectedDocTree!.children == nil || selectedDocTree!.children?.count <= 0{
            return;
        }
        selectedDocTree?.removeAllChild();

        // 3. 重载
        self.docTreeView.reloadData();
    }
}
