//
//  MarkdownHtmlTagFactory.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTagFactory: NSObject {
    
    
    static func getMarkdownHtmlTag(tagRegex: MarkdownManager.MarkdownRegex, range: Range<String.CharacterView.Index>) -> MarkdownHtmlTag{
        
        switch tagRegex {
        case .P:
            return MarkdownHtmlTag4p(range: range);
        case .CODE:
            return MarkdownHtmlTag4code(range: range);
        case .A1:
            return MarkdownHtmlTag4a1(range: range);
        case .A2:
            return MarkdownHtmlTag4a2(range: range);
        case .A3:
            return MarkdownHtmlTag4a3(range: range);
        case .BR:
            return MarkdownHtmlTag4br(range: range);
        case .HR:
            return MarkdownHtmlTag4hr(range: range);
        case .H1:
            return MarkdownHtmlTag4h1(range: range);
        case .H2:
            return MarkdownHtmlTag4h2(range: range);
        case .H3:
            return MarkdownHtmlTag4h3(range: range);
        case .H4:
            return MarkdownHtmlTag4h4(range: range);
        case .H5:
            return MarkdownHtmlTag4h5(range: range);
        case .H6:
            return MarkdownHtmlTag4h6(range: range);
        case .BOLD:
            return MarkdownHtmlTag4bold(range: range);
        case .ITALIC:
            return MarkdownHtmlTag4italic(range: range);
        case .U:
            return MarkdownHtmlTag4u(range: range);

        }
    }
}
