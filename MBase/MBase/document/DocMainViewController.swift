//
//  DocMainViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import WebKit

class DocMainViewController: NSViewController {
    
    @IBOutlet weak var webView: WebView!
    
    var markdown: String!;
    
    var docEditVerticalScroller: NSScroller?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshContent), name: "refreshContent", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(syncScroll), name: "syncScroll", object: nil);
    }
    
    func refreshContent(){
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(reloadHTML), object: nil);
        self.performSelector(#selector(reloadHTML), withObject: nil, afterDelay: 0.2);
    }
    
    func reloadHTML(){
        let start = CFAbsoluteTimeGetCurrent()
        let html = MarkdownManager.generateHTMLForMarkdown(self.markdown!, cssType: .Default);
        webView.mainFrame.loadHTMLString(html as String, baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!, isDirectory: true));
        
        // 恢复光标
        self.syncScroll();
        
        print("refreshContent===="+String(CFAbsoluteTimeGetCurrent()-start)+" seconds")
    }
    
    func syncScroll(){
//        print("==docEditVerticalScroller=="+String(docEditVerticalScroller?.floatValue))
        if docEditVerticalScroller == nil{
            return;
        }
        let webHtmlView = self.webView!.subviews[0].subviews[0].subviews[0].subviews[0];
        let webScrollView = self.webView!.subviews[0].subviews[0] as! NSScrollView;
        var frame = webScrollView.frame;
        if webHtmlView.frame.size.height > frame.size.height {
            frame.origin.y = (webHtmlView.frame.size.height - frame.size.height) * CGFloat(docEditVerticalScroller!.floatValue);
            webScrollView.contentView.scrollRectToVisible(frame);
        }
    }
}


