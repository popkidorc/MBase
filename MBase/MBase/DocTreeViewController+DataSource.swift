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
            let docTreeData: DocTreeData = item as! DocTreeData;
            return docTreeData.children!.count;
        }
        if docTree != nil {
            //不显示根
            return docTree.children!.count;
        } else {
            return 0;
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        let docTreeData: DocTreeData = item as! DocTreeData;
        return docTreeData.isHasChild;
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if (item != nil)
        {
            let docTreeData: DocTreeData = item as! DocTreeData;
            if docTreeData.isHasChild! {
                return docTreeData.children![index];
            }
        }
        //不显示根
        return docTree.children![index];
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        let cellView: NSTableCellView = outlineView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView;
        if tableColumn!.identifier == "DocTreeColumn" {
            let docTreeData: DocTreeData = item as! DocTreeData;
            cellView.objectValue = docTreeData.id;
            cellView.textField?.stringValue = docTreeData.name;
            cellView.imageView?.image = docTreeData.image;
        }
        return cellView;
    }
}
