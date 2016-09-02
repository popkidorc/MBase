//
//  MarkdownRegexEnum.swift
//  MBase
//
//  Created by sunjie on 16/9/2.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

enum MarkdownRegexLineEnum: String {
    
    static let values = [H1,H2,H3,H4,H5,H6,STRONG,EM,U,A1,A2,IMG1,IMG2,HR,BR];
    
    case BR = "(\\w+(\\s\\w+)*\\n$)"
    case HR = "(^- - -$)"
    
    case H1 = "(^\\# \\w+(\\s\\w+)*)"
    case H2 = "(^\\#\\# \\w+(\\s\\w+)*)"
    case H3 = "(^\\#\\#\\# \\w+(\\s\\w+)*)"
    case H4 = "(^\\#\\#\\#\\# \\w+(\\s\\w+)*)"
    case H5 = "(^\\#\\#\\#\\#\\# \\w+(\\s\\w+)*)"
    case H6 = "(^\\#\\#\\#\\#\\#\\# \\w+(\\s\\w+)*)"
    case EM = "(\\*\\w+(\\s\\w+)*\\*)"
    case STRONG = "(\\*\\*\\w+(\\s\\w+)*\\*\\*)"
    case U = "(_\\w+(\\s\\w+)*_)"
    
        
    case A1 = "(^\\[(.)*\\]\\((.)*\\)$)"
    case A2 = "(^\\[(.)*\\]\\[\\d{1,2}\\]$)"
    
    case IMG1 = "(^\\!\\[(.)*\\]\\((.)*\\)$)"
    case IMG2 = "(^\\!\\[(.)*\\]\\[\\d{1,2}\\]$)"
    
}
