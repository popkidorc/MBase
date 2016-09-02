//
//  MarkdownHtmlTagFactory.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTagFactory: NSObject {
    
    static func getMarkdownHtmlTag(tagRegex: MarkdownRegexCommonEnum, range: NSRange) -> MarkdownHtmlTagCommon{
        switch tagRegex {
        case .URL:
            return MarkdownHtmlTag4url(range: range);
            
        }
    }
    
    static func getMarkdownHtmlTag(tagRegex: MarkdownRegexLineEnum, range: NSRange) -> MarkdownHtmlTagLine{
        
        switch tagRegex {
            
        case .A1:
            return MarkdownHtmlTag4a1(range: range);
        case .A2:
            return MarkdownHtmlTag4a2(range: range);
        case .IMG1:
            return MarkdownHtmlTag4img1(range: range);
        case .IMG2:
            return MarkdownHtmlTag4img2(range: range);
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
        case .STRONG:
            return MarkdownHtmlTag4strong(range: range);
        case .EM:
            return MarkdownHtmlTag4em(range: range);
        case .U:
            return MarkdownHtmlTag4u(range: range);
            
        }
    }
    
    static func getMarkdownHtmlTag(tagRegex: MarkdownRegexParagraphEnum, range: NSRange) -> MarkdownHtmlTagParagraph{
        
        switch tagRegex {
        case .CODE1:
            return MarkdownHtmlTag4code1(range: range);
        case .CODE2:
            return MarkdownHtmlTag4code2(range: range);
        }
    }
}
