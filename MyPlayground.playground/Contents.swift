//: Playground - noun: a place where people can play

import Cocoa

//var str = "# asdfassafasdfsda \n **asjflljksaljflsjlfkas**"
//
//let range = str.startIndex.advancedBy(1)..<str.startIndex.advancedBy(3);

//var ss = NSString(string:"qwer```tyuiop```a123123123123sdf```ghjll1")
//
//
let s = NSString(string:"01`2```4`1````8```190");

let range = NSMakeRange(0, s.length);
    let searchString = "`"
    
    let exceptStrings = ["```"]
    
    if exceptStrings.count <= 0{
        NSString(string: searchString).rangeOfString(searchString, options: .BackwardsSearch, range: range);
    }
    var stringTemp = NSString(string:  s);
    for exceptString in exceptStrings {
        stringTemp = stringTemp.stringByReplacingOccurrencesOfString(exceptString, withString: "000", options: .BackwardsSearch, range: range)
    }
stringTemp.rangeOfString(searchString, options: .BackwardsSearch, range: range).location








