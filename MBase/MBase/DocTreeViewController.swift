//
//  DocTreeViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import CoreData

class DocTreeViewController: NSViewController {
    
    @IBOutlet weak var docTreeView: NSOutlineView!

    var docTreeData: DocTreeData!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    @IBAction func doubleAction(sender: AnyObject) {
        let docTree = self.selectedTree();
        if docTree == nil {
            return;
        }

        let docTreeInfoViewController = DocTreeInfoViewController(nibName: "DocTreeInfoViewController", bundle: nil);
        docTreeInfoViewController!.initData(docTree);
        
        let newSelectedRow = self.docTreeView.rowForItem(docTree);
        let rowView = self.docTreeView.rowViewAtRow(newSelectedRow, makeIfNecessary: false);
        
        docTreeInfoViewController!.showPopover(rowView, docTreeViewController: self);
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        let tree = NSEntityDescription.insertNewObjectForEntityForName("Tree", inManagedObjectContext: self.managedObjectContext) as! Tree;
        tree.name = "test1";
        tree.content = "123123123123131312";
        
        do{
            try managedObjectContext.save();
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
    }
    
    func initDocTreeDatas() {
        // 根
        docTreeData = DocTreeData();
        let tree1 = DocTreeData(id: 2, name: "tree1", image: NSImage(named: "centipedeThumb"), parent: docTreeData);
        let tree11 = DocTreeData(id: 3, name: "tree11", image: NSImage(named: "ladybugThumb"), parent: tree1);
        let tree12 = DocTreeData(id: 4, name: "tree12", image: NSImage(named: "wolfSpiderThumb"), parent: tree1);
        tree1.addChildTree(tree11);
        tree1.addChildTree(tree12);
        
        let tree2 = DocTreeData(id: 5, name: "tree2", image: NSImage(named: "wolfSpiderThumb"), parent: docTreeData);
        let tree21 = DocTreeData(id: 6, name: "tree21", image: NSImage(named: "potatoBugThumb"), parent: tree2);
        tree2.addChildTree(tree21);
        
        docTreeData.addChildTree(tree1);
        docTreeData.addChildTree(tree2);
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
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.docTreeData);
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "docTree");
        NSUserDefaults.standardUserDefaults().synchronize();
        
        
//        let navigationController = segue.destinationViewController as! UINavigationController
//        let bookAddTableViewController = navigationController.topViewController as! PKOBookAddTableViewController
        
        //这里注意要new一个NSManagedObjectContext，然后将self.fetchedResultsController?.managedObjectContext为其父context，这样我们在addView操作时就不会对self.fetchedResultsController?.managedObjectContext产生影响
//        let addContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType);
//        addContext.parentContext = self.fetchedResultsController?.managedObjectContext
//        
//        let newBook = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: addContext) as! Book
//        newBook.author = "Author1"//这里要初始化信息，不然为空的化swift会报错
//        newBook.title = "Titel1"
//        
//        
//        
//        newBook.theDate = NSDate()
//        
//        bookAddTableViewController.book = newBook
//        bookAddTableViewController.addObjectContext = addContext
//        bookAddTableViewController.delegate = self
    }
    
    func changeSelectedData(docTreeInfoData : DocTreeInfoData!, selectedDocTree:DocTreeData!){
        selectedDocTree?.name = docTreeInfoData.name;
        selectedDocTree?.image = docTreeInfoData.image;
        selectedDocTree?.content = docTreeInfoData.content;
        
        let selectedRow = self.docTreeView.rowForItem(selectedDocTree);
        let indexSet = NSIndexSet(index: selectedRow);
        let columnSet = NSIndexSet(index: 0);
        self.docTreeView.reloadDataForRowIndexes(indexSet, columnIndexes:columnSet);
    }
}

