//: Playground - noun: a place where people can play

import Cocoa

//var str = "# asdfassafasdfsda \n **asjflljksaljflsjlfkas**"
//
//let range = str.startIndex.advancedBy(1)..<str.startIndex.advancedBy(3);

var ss = NSString(string:"qwer```tyuiop```a123123123123sdf```ghjll1")


let s = "qwer```tyuiop```a123123123123sdf```ghjll1";
let searchString = ""

searchString == ""

searchString.rangeOfString("`") != nil

s.characters.count - s.stringByReplacingOccurrencesOfString(searchString, withString: "").characters.count;

let range = NSRange(location: 0, length: 16);

let string = NSString(string: s).substringWithRange(range);
let strCount = string.characters.count - string.stringByReplacingOccurrencesOfString(searchString, withString: "").characters.count;


//    - (NSInteger)countOccurencesOfString:(NSString*)searchString {
//        NSInteger strCount = [self length] - [[self stringByReplacingOccurrencesOfString:searchString withString:@""] length];
//        return strCount / [searchString length];
//}
let prerange = ss.rangeOfString("```", options: .BackwardsSearch, range: NSMakeRange(0, 30))

print(prerange)


let backrange = ss.rangeOfString("```", options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(30, ss.length-30))


print(backrange)






















