//
//  DocTreeData.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocTreeData: NSObject {

    var id: Int!;
    
    var name: String!;
    
    var number: Int!;
    
    var image: NSImage?;

    var level: Int!;
    
    var isHasChild: Bool!;
    
    var parent: DocTreeData?;
    
    var children: [DocTreeData]?;
    
    override init() {
        self.id = 1;
        self.name = "root";
        self.number = -1;
        self.image = nil;
        self.level = 0;
        self.parent = nil;
        self.isHasChild = false;
        self.children = [DocTreeData]();
    }

    init(id: Int!, name: String!, image: NSImage?, parent: DocTreeData!){
        self.id = id;
        self.name = name;
        if parent == nil {
            self.number = 0;
        } else if parent.children == nil || parent.children!.count <= 0 {
            self.number = 1;
        } else {
            self.number = parent.children!.last!.number + 1;
        }
        self.image = image;
        if parent == nil {
            self.level = 0;
        }else{
            self.level = (parent?.level)! + 1;
        }
        self.parent = parent;
        self.isHasChild = false;
        self.children = [DocTreeData]();
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init();
        self.id =  decoder.decodeObjectForKey("id") as! Int;
        self.name = decoder.decodeObjectForKey("name") as! String;
        self.number = decoder.decodeObjectForKey("number") as! Int;
        self.image = decoder.decodeObjectForKey("image") as! NSImage?;
        self.level = decoder.decodeObjectForKey("level") as! Int;
        self.isHasChild = decoder.decodeObjectForKey("isHasChild") as! Bool;
        self.parent = decoder.decodeObjectForKey("parent") as! DocTreeData?;
        self.children = decoder.decodeObjectForKey("children") as! [DocTreeData]?;
        
    }
    
    func setChildrenTree(children: [DocTreeData]?){
        if children == nil || children?.count <= 0 {
            self.isHasChild = false;
            self.children = [DocTreeData]();
        } else {
            self.isHasChild = true;
            self.children = children;
        }
    }
    
    func addChildTree(child: DocTreeData!){
        self.isHasChild = true;
        self.children?.append(child);
    }
    
    func getIndex() -> Int?{
        if self.parent == nil {
            return nil;
        }
        return self.parent!.children?.indexOf(self);
    }
    
    func getChildById(id: Int!) -> DocTreeData?{
        if self.children == nil || self.children?.count <= 0 {
            if id == self.id {
                return self;
            }else{
                return nil;
            }
        }
        for child in self.children! {
            return child.getChildById(id);
        }
        return nil;
    }
    
    func remove(){
        let index = self.getIndex();
        if index != nil {
            self.parent?.children?.removeAtIndex(index!);
        }
    }
}
