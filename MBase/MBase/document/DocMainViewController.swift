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
    
    override func viewDidLoad() {
        super.viewDidLoad();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshContent), name: "refreshContent", object: nil);
        // 启用计时器，控制每秒执行一次tickDown方法
//        NSTimer.scheduledTimerWithTimeInterval(1,target:self,selector:#selector(refreshContent), userInfo:nil,repeats:true)
        markdown = "";
        self.refreshContent();
    }
    
    func refreshContent(){
        print("refreshContent")
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(reloadHTML), object: nil);
        self.performSelector(#selector(reloadHTML), withObject: nil, afterDelay: 0.3);
    }
    
    
    func reloadHTML(){
        let start = CFAbsoluteTimeGetCurrent()
        let html = MarkdownManager.generateHTMLForMarkdown(self.markdown!, cssType: .Default);
        webView.mainFrame.loadHTMLString(html as String, baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!, isDirectory: true));
        print("refreshContent===="+String(CFAbsoluteTimeGetCurrent()-start)+" seconds")
    }
}


