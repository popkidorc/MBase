//: Playground - noun: a place where people can play

import Cocoa

//var str = "# asdfassafasdfsda \n **asjflljksaljflsjlfkas**"
//
//let range = str.startIndex.advancedBy(1)..<str.startIndex.advancedBy(3);

//var ss = NSString(string:"qwer```tyuiop```a123123123123sdf```ghjll1")
//
//
//let s = NSString(string:"01`2```4`1````8```190");
//
//let range = NSMakeRange(0, s.length);
//    let searchString = "`"
//    
//    let exceptStrings = ["```"]
//    
//    if exceptStrings.count <= 0{
//        NSString(string: searchString).rangeOfString(searchString, options: .BackwardsSearch, range: range);
//    }
//    var stringTemp = NSString(string:  s);
//    for exceptString in exceptStrings {
//        stringTemp = stringTemp.stringByReplacingOccurrencesOfString(exceptString, withString: "000", options: .BackwardsSearch, range: range)
//    }
//stringTemp.rangeOfString(searchString, options: .BackwardsSearch, range: range).location
//
//
//腐蚀制定ranges
//func corrodeString(ranges: [NSRange], corrodeRanges: [NSRange]) -> [NSRange]{
//    //完整range
//    let fullRange: NSRange = NSMakeRange(ranges[0].location, NSMaxRange(ranges[ranges.count - 1]))
//    //获取range坑集合
//    var holeRanges = [NSRange]();
//    var i = 0;
//    for range in ranges {
//        if i >= ranges.count - 1 {
//            break;
//        }
//        holeRanges[i] = NSMakeRange(NSMaxRange(range), ranges[i+1].location);
//        i += 1;
//    }
//    //组装holeRanges，追加corrodeRanges并重排序
//    holeRanges.appendContentsOf(corrodeRanges);
//    holeRanges = holeRanges.sort({ r1, r2 in r1.location < r2.location })
//    //腐蚀corrodeRanges
//    var corrodeResults = [NSRange]();
//    let j = 0;
//    for holeRange in holeRanges {
//        if j >= holeRanges.count - 1 || NSMaxRange(holeRange) > NSMaxRange(fullRange){
//            break;
//        }
//        corrodeResults[i] = NSMakeRange(NSMaxRange(holeRange), holeRanges[i+1].location);
//        i += 1;
//    }
//    return corrodeResults;
//}


let ranges = [NSMakeRange(0, 100), NSMakeRange(150, 50)]

let corrodeRanges = [NSMakeRange(0, 15), NSMakeRange(30, 30), NSMakeRange(160, 20)]

//获取range坑集合
var holeRanges = [NSRange]();
ranges.count
for index in 0 ..< ranges.count+1 {
    if index == 0 {
        holeRanges.append(NSMakeRange(ranges[0].location, 0));
        continue;
    } else if index == ranges.count {
        holeRanges.append(NSMakeRange(NSMaxRange(ranges[ranges.count - 1]), 0));
        continue;
    } else {
        holeRanges.append(NSMakeRange(NSMaxRange(ranges[index-1]), ranges[index].location - NSMaxRange(ranges[index-1])))
    }
}

//组装holeRanges，追加corrodeRanges并重排序
holeRanges.appendContentsOf(corrodeRanges);
holeRanges = holeRanges.sort({ r1, r2 in r1.location < r2.location })
holeRanges
for a in holeRanges{
    a.location
    a.length
}

//腐蚀corrodeRanges
var corrodeResults = [NSRange]();
for index in 0 ..< holeRanges.count {
    if index == 0 {
        continue;
    } else if holeRanges[index].location > NSMaxRange(holeRanges[index-1]){
        corrodeResults.append(NSMakeRange(NSMaxRange(holeRanges[index-1]), holeRanges[index].location - NSMaxRange(holeRanges[index-1])));
    }
}

for b in corrodeResults{
    b.location
    b.length
}









