//
//  UserInfo.swift
//  MBase
//
//  Created by sunjie on 16/8/8.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Foundation
import CoreData


class UserInfo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func initData(){
        let nowDate = NSDate()
        self.createtime = nowDate;
        self.modifytime = nowDate;
    }
    
    func updateSelectedDocTree(selectedDocTree : DocTree){
        self.selectDocTree = selectedDocTree;
        let nowDate = NSDate()
        self.modifytime = nowDate;
    }
}
