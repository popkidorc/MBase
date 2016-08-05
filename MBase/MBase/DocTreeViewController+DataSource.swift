//
//  DocTreeViewController+DataSource.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocTreeViewController: NSOutlineViewDataSource {
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if (item != nil)
        {
            let docTreeData = item as! DocTree;
            return docTreeData.children!.count;
        }
        if docTreeData != nil {
            //不显示根
            return docTreeData.children!.count;
        } else {
            return 0;
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        let docTreeData = item as! DocTree;
        
        if docTreeData.children == nil || docTreeData.children?.count <= 0 {
            return false;
        } else {
            return true;
        }
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if (item != nil)
        {
            let docTreeData = item as! DocTree;
            if docTreeData.children != nil {
                return docTreeData.children![index];
            }
        }
        //不显示根
        return docTreeData.children![index];
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        let cellView: NSTableCellView = outlineView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView;
        if tableColumn!.identifier == "DocTreeColumn" {
            let docTreeData = item as! DocTree;
            cellView.objectValue = docTreeData.objectID;
            cellView.textField?.stringValue = docTreeData.name!;
            if docTreeData.image != nil {
                cellView.imageView?.image = NSImage(data: docTreeData.image!);
            }
        }
        return cellView;
    }
}
