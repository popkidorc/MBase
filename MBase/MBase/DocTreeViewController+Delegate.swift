//
//  DocTreeViewController+Delegate.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocTreeViewController: NSOutlineViewDelegate {

    func outlineViewSelectionDidChange(notification: NSNotification) {
        print("outlineViewSelectionDidChange");
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        if DocTree.DocTreeType.Trash.rawValue == selectedDocTree?.type {
            return;
        }
        //获取并展示docmain
        self.docEditViewController.initDocEditDatas(selectedDocTree?.docMain);
    }
    
}
