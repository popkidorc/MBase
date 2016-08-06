//
//  DocTreeViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import CoreData

class DocTreeViewController: NSViewController, NSDraggingDestination {
    
    @IBOutlet weak var docTreeView: NSOutlineView!
    
    var docTreeData: DocTree!;
    
    var docEditViewController: DocEditViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    @IBAction func doubleAction(sender: AnyObject) {
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        if DocTree.DocTreeType.Trash.rawValue == selectedDocTree?.type {
            return;
        }
        
        let docTreeInfoViewController = DocTreeInfoViewController(nibName: "DocTreeInfoViewController", bundle: nil);
        docTreeInfoViewController!.initData(selectedDocTree);
        
        let newSelectedRow = self.docTreeView.rowForItem(selectedDocTree);
        let rowView = self.docTreeView.rowViewAtRow(newSelectedRow, makeIfNecessary: false);
        
        docTreeInfoViewController!.showPopover(rowView, docTreeViewController: self);
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        self.docTreeView.registerForDraggedTypes([NSPasteboardTypeString]);
    }
    
    func initDocTreeDatas() {
        // 1. 加载数据，查询coredata
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        //        fetchRequest.fetchOffset = 0 //查询的偏移量
        //设置数据请求的实体结构
        fetchRequest.entity = NSEntityDescription.entityForName("DocTree",
                                                                inManagedObjectContext: self.managedObjectContext);
        //设置查询条件
        let predicate = NSPredicate(format: "1=1 ", "")
        fetchRequest.predicate = predicate
        
        //查询操作
        var trees = [DocTree]();
        do{
            trees = try managedObjectContext.executeFetchRequest(fetchRequest) as! [DocTree];
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        
        //遍历查询的结果
        if trees.count > 0 {
            // 1.1. 添加到coredata
            self.initDataByCoreData(trees);
        } else {
            // 1.2. 初始化默认值
            self.initDataByDefaultData();
        }
    }
    
    func initDataByCoreData(trees: [DocTree]){
        for tree in trees {
            if tree.number == -1 {
                docTreeData = tree;
            }
        }
    }
    
    // 初始化默认值
    func initDataByDefaultData(){
        docTreeData = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        docTreeData.initData4Root();
        
        let tree1 = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        let main1 = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
        main1.initData("", summary: "", mark: "", type: DocMain.DocMainType.Markdown, docTree: tree1);
        tree1.initData("回收站", content: "回收站", image: NSImage(named: "ladybugThumb"), type: DocTree.DocTreeType.Trash, parent: docTreeData, docMain: main1);
        
        let tree2 = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        let main2 = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
        main2.initData("", summary: "", mark: "", type: DocMain.DocMainType.Markdown, docTree: tree2);
        tree2.initData("我的文档", content: "我的文档", image: NSImage(named: "centipedeThumb"), type: DocTree.DocTreeType.Normal, parent: docTreeData, docMain: main2);
        
        
        
        docTreeData.addChildTree(tree1);
        docTreeData.addChildTree(tree2);
    }
    
    func selectedTree() -> DocTree? {
        let selectedRow = self.docTreeView.selectedRow;
        if selectedRow >= 0 {
            return docTreeView.itemAtRow(selectedRow) as? DocTree;
        }
        return nil
    }
    
    func changeSelectedData(docTreeInfoData : DocTreeInfoData!, selectedDocTree: DocTree!){
        selectedDocTree.updateData(docTreeInfoData.name, content: docTreeInfoData.content, image: docTreeInfoData.image, type: DocTree.DocTreeType.Normal);
        
        let selectedRow = self.docTreeView.rowForItem(selectedDocTree);
        let indexSet = NSIndexSet(index: selectedRow);
        let columnSet = NSIndexSet(index: 0);
        self.docTreeView.reloadDataForRowIndexes(indexSet, columnIndexes:columnSet);
    }

    func moveNode(sourceDocTree: DocTree, targetParentDocTree: DocTree, targetIndex: Int?){
        if sourceDocTree.parent == nil{
            return;
        }
        var childIndex: Int;
        if targetIndex == nil{
            childIndex = targetParentDocTree.children!.count;
        } else {
            childIndex = targetIndex!;
        }
        // 1. 更新Tree
        targetParentDocTree.insertChildTree(sourceDocTree, index: childIndex);
        if sourceDocTree.parent! != targetParentDocTree{
            //原父类移除该Doctree,由于index原因需要在insert之后执行
            sourceDocTree.parent!.removeChild(sourceDocTree);
            sourceDocTree.updateParentTree(targetParentDocTree);
        }
        
        // 2. 重载数据
        self.docTreeView.reloadData();

        // 3. 选中并滚动到新行
        let newSelectedRow = self.docTreeView.rowForItem(sourceDocTree);
        self.docTreeView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
        self.docTreeView.scrollRowToVisible(newSelectedRow);
    }
}

