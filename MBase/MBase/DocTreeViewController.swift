//
//  DocTreeViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocTreeViewController: NSViewController {
    
    @IBOutlet weak var docTreeView: NSOutlineView!
    
    var docTree: DocTreeData!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initDocTreeDatas() {
        // 根
        docTree = DocTreeData();
        let tree1 = DocTreeData(id: 2, name: "tree1", image: NSImage(named: "centipedeThumb"), parent: docTree);
        let tree11 = DocTreeData(id: 3, name: "tree11", image: NSImage(named: "ladybugThumb"), parent: tree1);
        let tree12 = DocTreeData(id: 4, name: "tree12", image: NSImage(named: "wolfSpiderThumb"), parent: tree1);
        tree1.addChildTree(tree11);
        tree1.addChildTree(tree12);
        
        let tree2 = DocTreeData(id: 5, name: "tree2", image: NSImage(named: "wolfSpiderThumb"), parent: docTree);
        let tree21 = DocTreeData(id: 6, name: "tree21", image: NSImage(named: "potatoBugThumb"), parent: tree2);
        tree2.addChildTree(tree21);
        
        docTree.addChildTree(tree1);
        docTree.addChildTree(tree2);
    }
    
    func selectedTree() -> DocTreeData? {
        let selectedRow = self.docTreeView.selectedRow;
        if selectedRow >= 0 {
            let item = docTreeView.itemAtRow(selectedRow);
            if item != nil {
                let docTree : DocTreeData = docTreeView.itemAtRow(selectedRow) as! DocTreeData;
                return docTree;
            }
        }
        return nil
    }
    
    func saveDatas() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.docTree);
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "docTree");
        NSUserDefaults.standardUserDefaults().synchronize();
    }
}

