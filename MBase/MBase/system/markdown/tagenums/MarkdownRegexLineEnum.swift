//
//  MarkdownRegexEnum.swift
//  MBase
//
//  Created by sunjie on 16/9/2.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

enum MarkdownRegexLineEnum: String {
    
    static let values = [H6,H5,H4,H3,H2,H1,STRONG,EM,U,A1,A2,IMG1,IMG2,HR];
    
    case HR = "(^- - -$)"
    
    case H1 = "(\\# \\w+(\\S\\w+)*)"
    case H2 = "(\\#\\# \\w+(\\S\\w+)*)"
    case H3 = "(\\#\\#\\# \\w+(\\S\\w+)*)"
    case H4 = "(\\#\\#\\#\\# \\w+(\\S\\w+)*)"
    case H5 = "(\\#\\#\\#\\#\\# \\w+(\\S\\w+)*)"
    case H6 = "(\\#\\#\\#\\#\\#\\# \\w+(\\S\\w+)*)"
    case EM = "(\\*\\w+(\\S\\w+)*\\*)"
    case STRONG = "(\\*\\*\\w+(\\S\\w+)*\\*\\*)"
    case U = "(_\\w+(\\S\\w+)*_)"
        
    case A1 = "(^\\[(.)*\\]\\((.)*\\)$)"
    case A2 = "(^\\[(.)*\\]\\[\\d{1,2}\\]$)"
    
    case IMG1 = "(^\\!\\[(.)*\\]\\((.)*\\)$)"
    case IMG2 = "(^\\!\\[(.)*\\]\\[\\d{1,2}\\]$)"
    
}
