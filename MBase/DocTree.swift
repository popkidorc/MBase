//
//  DocTree.swift
//  MBase
//
//  Created by sunjie on 16/8/5.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Foundation
import CoreData


class DocTree: NSManagedObject {

    enum DocTreeType : String {
        case Root = "Root"
        case Normal = "Normal"
        case Trash = "Trash"
    }
    
    enum DocTreeStatus : String {
        case Enabled = "Enabled"
        case Deleted = "Deleted"
    }
    
    func initData4Root() {
        self.name = "root";
        self.number = NSNumber(long: -1);
        self.image = nil;
        self.level = NSNumber(long: 0);
        self.parent = nil;
        self.children = NSMutableOrderedSet();
        self.content = "";
        self.type = DocTreeType.Root.rawValue;
        self.status = DocTreeStatus.Enabled.rawValue;
        self.docMain = nil;
        let nowDate = NSDate()
        self.createtime = nowDate;
        self.modifytime = nowDate;
    }
    
    func initData(name: String!, content: String?, image: NSImage?, type: DocTreeType?, parent: DocTree!, docMain: DocMain!){
        self.name = name;
        if parent == nil {
            self.number = NSNumber(long: 0);
        } else if parent.children == nil || parent.children!.count <= 0 {
            self.number = NSNumber(long: 1);
        } else {
            self.number = NSNumber(long: parent.children!.objectAtIndex(parent.children!.count - 1).number!!.longValue + 1 );
        }
        if image == nil{
            self.image = nil;
        } else {
            self.image = image?.TIFFRepresentation;
        }
        if parent == nil {
            self.level = NSNumber(long: 0);
        } else {
            self.level = NSNumber(long: parent!.level!.longValue + 1);
        }
        self.content = content;
        self.children = NSMutableOrderedSet();
        self.parent = parent;
        if type == nil || DocTreeType.Root == type{
            self.type = DocTreeType.Normal.rawValue;
        } else {
            self.type = type!.rawValue;
        }
        if type == nil || DocTreeType.Trash == type{
            self.docMain = nil;
        } else {
            self.docMain = docMain;
        }
        let nowDate = NSDate();
        self.createtime = nowDate;
        self.modifytime = nowDate;
    }
    
    func updateData(name: String!,content: String?, image: NSImage?, type: DocTreeType?){
        self.name = name;
        self.image = image?.TIFFRepresentation;
        self.content = content;
        if type == nil || DocTreeType.Root == type {
            self.type = DocTreeType.Normal.rawValue;
        }else{
            self.type = type!.rawValue;
        }
        let nowDate = NSDate();
        self.modifytime = nowDate;
    }
    
    func addChildTree(child: DocTree!){
        self.children!.addObject(child!);
        let nowDate = NSDate();
        self.modifytime = nowDate;//一定要赋值，只修改children的话managedObjectContext.hasChanges会认为没有改动
    }
    
    func insertChildTree(child: DocTree!,index: Int){
        if child.parent != nil && self == child.parent {
            let oldIndex = self.children!.indexOfObject(child);
            var newIndex = 0;
            if index > oldIndex {
                newIndex = index-1;
            }else{
                newIndex = index;
            }
            self.children!.removeObject(child);
            self.children!.insertObject(child, atIndex: newIndex);
        }else{
            self.children!.insertObject(child, atIndex: index);
        }
        let nowDate = NSDate();
        self.modifytime = nowDate;//一定要赋值，只修改children的话managedObjectContext.hasChanges会认为没有改动
    }
    
    func updateParentTree(parent: DocTree!){
        self.parent = parent;
        let nowDate = NSDate();
        self.modifytime = nowDate;//一定要赋值，只修改children的话managedObjectContext.hasChanges会认为没有改动
    }
    
    func getIndex() -> Int?{
        if self.parent == nil {
            return nil;
        }
        return self.parent!.children?.indexOfObject(self);
    }
    
    func move2Trash(){
        self.status = DocTreeStatus.Deleted.rawValue;
    }
    
    func remove(){
        self.parent?.children?.removeObject(self);
        let nowDate = NSDate();
        self.parent?.modifytime = nowDate;//一定要赋值，只修改children的话managedObjectContext.hasChanges会认为没有改动
    }
    
    func removeAllChild(){
        self.children = NSMutableOrderedSet();
        let nowDate = NSDate();
        self.modifytime = nowDate;//一定要赋值，只修改children的话managedObjectContext.hasChanges会认为没有改动
    }
    
    func removeChild(child: DocTree){
        self.children?.removeObject(child);
        let nowDate = NSDate();
        self.modifytime = nowDate;//一定要赋值，只修改children的话managedObjectContext.hasChanges会认为没有改动
    }
}
