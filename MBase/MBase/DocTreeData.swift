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

    init(id: Int!, name: String!, number: Int!, image: NSImage?, parent: DocTreeData?){
        self.id = id;
        self.name = name;
        self.number = number;
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
