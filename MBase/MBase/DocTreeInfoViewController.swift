//
//  DocTreeInfoViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/23.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocTreeInfoViewController: NSViewController {

    @IBOutlet weak var nameField: NSTextField!
    
    @IBOutlet var contentField: NSTextView!
    
    @IBOutlet weak var imageView: NSImageView!
    
    var docTreeInfoPopover: NSPopover?;
    
    var docTreeInfoData : DocTreeInfoData?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化数据
        self.initView();
    }
    
    func initData(docTree: DocTreeData?) {
        self.docTreeInfoData = DocTreeInfoData();
        if docTree != nil {
            self.docTreeInfoData!.id = docTree!.id;
            self.docTreeInfoData!.name = docTree!.name;
            self.docTreeInfoData!.content = docTree!.content;
            self.docTreeInfoData!.image = docTree!.image;
        }
    }
    
    func initView() {
        if self.docTreeInfoData == nil {
            return;
        }
        self.nameField.stringValue = self.docTreeInfoData!.name;
        self.contentField.string = self.docTreeInfoData!.content;
        self.imageView.image = self.docTreeInfoData!.image;
    }
    
    func showPopover(ofView: NSView!){
        docTreeInfoPopover = NSPopover();
        docTreeInfoPopover!.contentViewController = self;
        docTreeInfoPopover!.delegate = self;
        docTreeInfoPopover!.behavior = NSPopoverBehavior.Transient;
        docTreeInfoPopover!.showRelativeToRect(ofView!.bounds, ofView: ofView!, preferredEdge: NSRectEdge.MaxY);
    }
    
}
