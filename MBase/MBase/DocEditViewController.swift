//
//  DocEditViewController.swift
//  MBase
//
//  Created by sunjie on 16/8/3.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import CoreData
import WebKit

class DocEditViewController: NSViewController {
    
    @IBOutlet var docEditView: DocEditTextView!
    
    @IBOutlet weak var docEditScrollView: NSScrollView!
    
    var docEditTextStorage: DocEditTextStorage!;
    
    var docMainData: DocMain!;
    
    var docMainViewController: DocMainViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        initDocEidtView()
    }
    
    func initDocEditDatas(docMainData: DocMain!){
        self.docMainData = docMainData;
        if DocMain.DocMainType.NotEdit.rawValue == docMainData.type {
            self.docEditView.editable = false;
            self.docEditView.backgroundColor = ConstsManager.docEditDisableBgColor;
        }else{
            self.docEditView.editable = true;
            self.docEditView.backgroundColor = ConstsManager.docEditEnableBgColor;
        }
        
        let attrs = [NSFontAttributeName:NSFont.systemFontOfSize(ConstsManager.defaultFontSize)];
        let attrString = NSAttributedString(string: docMainData.content!, attributes: attrs);
        self.docEditTextStorage.setAttributedString(attrString);
        
        docMainViewController.markdown = docMainData.content!;
        self.docMainViewController.refreshContent();
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //需要长时间处理的代码
            print("12312312312312312")
            
            dispatch_async(dispatch_get_main_queue(), {
                //需要主线程执行的代码
            })
        })
    }
    
    func initDocEidtView() {
        // 1. 初始化用于备份编辑器中文本的存储器
        self.docEditTextStorage = DocEditTextStorage();
        self.docEditView.textContainerInset = NSSize(width: 10, height: 50);
        
        // 2. 创建layoutManager
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(self.docEditView.textContainer!)
        docEditTextStorage.addLayoutManager(layoutManager)
        docEditTextStorage.docEditView = self.docEditView;
        
        // 3. View属性
        // 3.1. 拉宽自动补充
        self.docEditView.textContainer!.widthTracksTextView = true;
        // 3.2. 剪切版
        self.docEditView.registerForDraggedTypes([NSPasteboardTypeString,NSPasteboardTypePNG]);
        // 3.3. 状态＋颜色
        self.docEditView.editable = false;
        self.docEditView.backgroundColor = ConstsManager.docEditDisableBgColor;
        
        //给滚动条添加通知
        let scrollContentView = docEditScrollView.contentView;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(boundDidChange), name: NSViewBoundsDidChangeNotification, object: scrollContentView)
    }
    
    func boundDidChange(){
        if docEditScrollView.hasVerticalScroller{
            if docEditView.frame.size.height > docEditScrollView.frame.size.height{
                let webScrollView = docMainViewController.webView!.subviews[0].subviews[0] as! NSScrollView;
                var frame = webScrollView.frame;
                frame.origin.y = docEditScrollView.frame.size.height * (docEditView.frame.size.height/frame.size.height) * CGFloat(docEditScrollView.verticalScroller!.floatValue);
                webScrollView.contentView.scrollRectToVisible(frame);
            }
            
        }
    }
    
}