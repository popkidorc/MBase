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
        super.viewDidLoad()
        markdown = "";
        self.refreshContent();
    }
    
    func refreshContent(){
        if let html = Hoedown.renderHTMLForMarkdown(markdown!, flags: [.SkipHTML, .Escape, .HardWrap, .UseXHTML], extensions: [.Tables, .FencedCodeBlocks, .FootNotes, .AutoLinkURLs,  .StrikeThrough, .Underline, .Highlight, .Quote, .Superscript, .Math, .DisableIndentedCode, .NoIntraEmphasis, .SpaceHeaders, .MathExplicit ]) {
            webView.mainFrame.loadHTMLString(html, baseURL: nil)
        }
    }
    
}


extension DocMainViewController: WebPolicyDelegate {
    func webView(webView: WebView!, decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!, request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
        let navigationType = actionInformation[WebActionNavigationTypeKey] as! NSNumber
        guard case .LinkClicked = WebNavigationType(rawValue: navigationType.integerValue)! else {
            listener.use()
            return
        }
        guard let URL = actionInformation[WebActionOriginalURLKey] as? NSURL else {
            listener.use()
            return
        }
        
        listener.ignore()
        NSWorkspace.sharedWorkspace().openURL(URL)
    }
}