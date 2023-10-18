//
//  String+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

extension String {
    public init(_ aClass: AnyClass) {
        self = "\(aClass.self)"
    }
    
//    func toLink() -> PPStringProtocol {
//        return self as PPStringProtocol
//    }
    
    public static func length(_ string: String?) -> Int{
        guard let string = string else { return 0 }
        return string.count
    }
    
    public static func isEmpty(_ string: String?) -> Bool {
        guard let str = string else { return true }
        return str.length == 0
    }
    
    public func toPrice() -> String{
        if self == "0" { return "0" }
        guard let money = Double(self) else { return "0" }
        let tempMoney = money / 100
        if String(tempMoney).contains(".00") || String(tempMoney).hasSuffix(".0") {
            return String(format: "%.0f", tempMoney)
        } else {
            return String(format: "%.2f", tempMoney)
        }
    }

    /**
     * 用法
     let str = "Hello, world"
     print(str[...4]) // "Hello"
     print(str[..<5]) // "Hello"
     print(str[7...]) // "world"
     print(str[3...4] + str[2]) // "lol"
     */
    
    public subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    public subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    public subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    public subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    public subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    public subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
    }
    
    
    public func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    public func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    
    public func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    
    public func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    
    public func replacingOccurrences(of search: String, with replacement: String, count maxReplacements: Int) -> String {
            var count = 0
            var returnValue = self

            while let range = returnValue.range(of: search) {
                returnValue = returnValue.replacingCharacters(in: range, with: replacement)
                count += 1

                // exit as soon as we've made all replacements
                if count == maxReplacements {
                    return returnValue
                }
            }

            return returnValue
        }
    
    public func toRange(_ range: NSRange) -> Range<String.Index>? {
            guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
            guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
            guard let from = String.Index(from16, within: self) else { return nil }
            guard let to = String.Index(to16, within: self) else { return nil }
            return from ..< to
    }
}

extension Double {
    public func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    public func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension NSMutableAttributedString {
    
    public func appending(_ tail: NSAttributedString) -> NSMutableAttributedString {
        self.append(tail)
        return self
    }
    
    public static func attribute(_ text: String,
                          _ color: UIColor,
                          font: UIFont,
                          range: NSRange) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attributedText.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        return attributedText
    }
}


extension String {
    
    public func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    public var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    public func attribute(_ color: UIColor,
                   font: UIFont,
                   range: NSRange) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attributedText.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        return attributedText
    }
    
    public func attributeStrikethroughStyle(_ color: UIColor,
                   font: UIFont) -> NSMutableAttributedString {
        let range = NSMakeRange(0, self.length)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attributedText.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: range)
        return attributedText
    }
}

extension String {
    
    public var length: Int {
        let set = NSCharacterSet.whitespacesAndNewlines
        let string = NSString(string: self as NSString)
        let filter = string.trimmingCharacters(in: set)
        return filter.count
    }
    
    public var int: Int {
        return Int(self) ?? 0
    }
    
    public func doubleValue() -> Double {
        var value: Double = 0
        if let a = Double(self) {
            value = a.roundTo(places: 4)
        }
        return value
    }
    
    public func intValue() -> Int {
        var value: Int = 0
        if let a = Int(self) {
            value = a
        }
        return value
    }
    
    public func numberValue() -> NSNumber {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: self) {
            return number
        }
        return NSNumber(value: 0)
    }
    
    public func textAutoWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let string = self as NSString
        let rect = string.boundingRect(with:CGSize(width: width, height:0),
                                       options: [.usesLineFragmentOrigin, .usesFontLeading],
                                       attributes: [NSAttributedString.Key.font:font],
                                       context:nil)
        return rect.width
    }
    
    public func textAutoSize(width: CGFloat, font: UIFont) -> CGSize {
        let string = self as NSString
        let rect = string.boundingRect(with:CGSize(width: width, height:0),
                                       options: [.usesLineFragmentOrigin, .usesFontLeading],
                                       attributes: [NSAttributedString.Key.font:font],
                                       context:nil)
        return rect.size
    }
}

extension String {
    public func index(from: Int) -> Index {
        
        return self.index(startIndex, offsetBy: from)
    }
    
    public func substring(from: Int) -> String {
        return String(self[from...])
    }
    
    public func substring(to: Int) -> String {
        return String(self[..<to])
    }
    
    public func substring(with r: Range<Int>) -> String {
        return String(self[r.lowerBound..<r.upperBound])
    }
    
}

extension String {
    
    public func validateEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    public var toURL: URL? {
        return URL(string: self)
    }
    
    public func toDictionary() -> Dictionary<String, AnyObject>? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as?  Dictionary<String, AnyObject>
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    public func toArray() -> [Dictionary<String, AnyObject>]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Dictionary<String, AnyObject>]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    public func isEqualToString(_ find: String!) -> Bool! {
        return String(format: self) == find
    }
    
    public func callNumber() {
        guard let number = URL(string: "tel://" + self) else { return }
        let application: UIApplication = UIApplication.shared
        
        if #available(iOS 10.0, *) {
            application.open(number)
        } else {
            if (application.canOpenURL(number)) {
                application.openURL(number)
            } else if let phoneCallURL: URL = URL(string: "telprompt://\(self)") {
                if (application.canOpenURL(phoneCallURL)) {
                    application.openURL(phoneCallURL)
                }
            }
        }
    }
    
    public func toDate(withFormatter formatter: String) -> Date? {
        let format = DateFormatter()
        format.dateFormat = formatter
        return format.date(from: self)
    }
    
    public func toDate(withFormatter formatter: DateFormatter) -> Date? {
        return formatter.date(from: self)
    }
}

public func checkStringAvailable(_ str: String?) -> Bool {
    return str != nil && str!.length > 0
}

extension String {
    public func generateAttributedString(with searchTerm: String, highlightSearchTermColor: UIColor) -> NSAttributedString? {
        let attributedString = NSMutableAttributedString(string: self)
        do {
            let regex = try NSRegularExpression(pattern: searchTerm, options: .caseInsensitive)
            let range = NSRange(location: 0, length: self.utf16.count)
            for match in regex.matches(in: self, options: .withTransparentBounds, range: range) {
                if #available(iOS 8.2, *) {
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: highlightSearchTermColor, range: match.range)
                } else {
                    // Fallback on earlier versions
                }
            }
            return attributedString
        } catch _ {
            return attributedString
        }
    }
    
    public func generateAttributedString(color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 0, length: self.length))
        return attributedString
    }
    
}

extension CharacterSet {
    public static var urlQueryParametersAllowed: CharacterSet {
        // Does not include "?" or "/" due to RFC 3986 - Section 3.4
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return allowedCharacterSet
    }
}

extension String {
    
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    public var pathExtension: String {
        return (self as NSString).pathExtension
    }
    public var stringByDeletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    public var stringByDeletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    public var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    public func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    public func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
}

extension String {
    public func encodeUTF8() -> String? {
        if let _ = URL(string: self) {
            return self
        }
        let optionalLastComponent = self.split { $0 == "/" }.last
        if let lastComponent = optionalLastComponent {
            let lastComponentAsString = lastComponent.map { String($0) }.reduce("", +)
            if let rangeOfLastComponent = self.range(of: lastComponentAsString) {
                let stringWithoutLastComponent = String(self[..<rangeOfLastComponent.lowerBound])
                if let lastComponentEncoded = lastComponentAsString.addingPercentEncoding(withAllowedCharacters: .urlQueryParametersAllowed) {
                    let encodedString = stringWithoutLastComponent + lastComponentEncoded
                    return encodedString
                }
            }
        }
        return nil
    }
    
    //将原始的url编码为合法的url
    public func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    public func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}

extension String{
    ///文件大小计算
    public func transformFileSizeUnit() -> String {
        
        var convertedValue = Double(self.replacingOccurrences(of: ",", with: "")) ?? 0
        var fileSizeUnit: Int = 0
        let units = ["b", "Kb", "Mb", "Gb", "Tb", "Pb", "Eb"]
        while convertedValue > 1024.00 {
            convertedValue /= 1024.00
            fileSizeUnit += 1
        }
        
        return String(format: "%.2f", convertedValue) + units[fileSizeUnit]
        
    }
}

extension String {
    ///字符串是否包含子字符串
    public func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    public func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

/// 字符串数字改变Formatter
extension String {
    public func changNumberFormatter(_ from: NumberFormatter, _ to: NumberFormatter) -> String? {
        guard let number = from.number(from: self) else { return nil }
        return to.string(from: number)
    }
}

// 时间格式转换
extension String {
    public func changDateFormatter(_ from: DateFormatter, _ to: DateFormatter) -> String? {
        guard let date = from.date(from: self) else { return nil }
        return to.string(from: date)
    }
}

// 时间格式转换
extension String {
    public func dateToTimeStamp(formatter : DateFormatter) -> Int{
        guard self.length != 0 else {
            return 0
        }
        let date = formatter.date(from: self)
        //10位数时间戳
        if let date = date{
            return Int(date.timeIntervalSince1970*1000)
        } else {
            return 0
        }
    }
}

extension String{
    public func deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    public func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag: tag)
        }
        return mutableString
    }
    
    ///去掉字符串标签
    public mutating func filterHTML() -> String?{
        let scanner = Scanner(string: self)
        var text: NSString?
        while !scanner.isAtEnd {
            scanner.scanUpTo("<", into: nil)
            scanner.scanUpTo(">", into: &text)
            self = self.replacingOccurrences(of: "\(text == nil ? "" : text!)>", with: "")
        }
        return self
    }
    
    /// 获取文本中的地址
    public func getHTMLUrlFor() -> [String] {
        var _arrItem = [String]()
        
        let strRegex = "([hH][tT]{2}[pP]://|[hH][tT]{2}[pP][sS]://)(([A-Za-z0-9-~]+).)+([A-Za-z0-9-~\\/])+"
        if let regexps:NSRegularExpression = try? NSRegularExpression.init(pattern: strRegex, options: NSRegularExpression.Options(rawValue: 0)) {
            
            let stringRange = NSMakeRange(0, self.utf16.count)
            regexps.enumerateMatches(in: self,
                                     options: NSRegularExpression.MatchingOptions.init(rawValue: 0),
                                     range: stringRange) { (result:NSTextCheckingResult?, _:NSRegularExpression.MatchingFlags, _:UnsafeMutablePointer<ObjCBool>) in
                //可能为网址的字符串及其所在位置
                if let urlRange = result?.range {
                    let _nt = NSString.init(string: self).substring(with: urlRange)
                    _arrItem.append(_nt)
                }
            }
        }
        return _arrItem
    }
}
