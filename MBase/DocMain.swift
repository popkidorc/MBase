//
//  DocMain.swift
//  MBase
//
//  Created by sunjie on 16/8/5.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Foundation
import CoreData


class DocMain: NSManagedObject {
    
    enum DocMainType : String {
        case Markdown = "Markdown"
    }
    
    func initData(content: String!, summary: String?, mark: String?, type: DocMainType?, docTree: DocTree!) {
        self.content = content;
        self.summary = summary;
        self.mark = mark;
        if type == nil {
            self.type = DocMainType.Markdown.rawValue;
        } else {
            self.type = type!.rawValue;
        }
        let nowDate = NSDate()
        self.createtime = nowDate;
        self.modifytime = nowDate;
        self.docTree = docTree;
    }

    func updateContent(content: String){
        self.content = content;
        let nowDate = NSDate();
        self.modifytime = nowDate;
    }
    
}
