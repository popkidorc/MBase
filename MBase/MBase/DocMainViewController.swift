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
        var html = Hoedown.renderHTMLForMarkdown(markdown!, flags: [.SkipHTML, .Escape, .HardWrap, .UseXHTML], extensions: [.Tables, .FencedCodeBlocks, .FootNotes, .AutoLinkURLs,  .StrikeThrough, .Underline, .Highlight, .Quote, .Superscript, .Math, .DisableIndentedCode, .NoIntraEmphasis, .SpaceHeaders, .MathExplicit ]);
        if html != nil {
            html = html!.stringByReplacingOccurrencesOfString("&lt;", withString: "<");
            html = html!.stringByReplacingOccurrencesOfString("&gt;", withString: ">");
            html = html!.stringByReplacingOccurrencesOfString("&quot;", withString: "\"");
            html = html!.stringByReplacingOccurrencesOfString("&amp;", withString: "&");
            webView.mainFrame.loadHTMLString(html!, baseURL: nil)
        }
    }
}


