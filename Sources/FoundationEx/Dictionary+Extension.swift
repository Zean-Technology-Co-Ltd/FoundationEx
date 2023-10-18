//
//  Dictionary+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import Foundation

public extension Dictionary {
    
    func toString(_ phoneNumber: String) -> String {
        //首先判断能不能转换
        if (!JSONSerialization.isValidJSONObject(self)) {
            //print("is not a valid json object")
            return ""
        }

        //利用OC的json库转换成OC的NSData，
        //如果设置options为NSJSONWritingOptions.PrettyPrinted，则打印格式更好阅读
        let data : Data! = try? JSONSerialization.data(withJSONObject: self, options: [])
        //NSData转换成NSString打印输出
        let str = NSString(data:data, encoding: String.Encoding.utf8.rawValue)
        //输出json字符串
        return str! as String
    }
    
    static func isNoElement(_ dict: [String: Any]?) -> Bool {
        guard let dict = dict else {
            return true
        }
        return dict.isEmpty
    }
    
    func queryUrlToString() -> String {
        guard let params = self as? [String: String] else { return "" }
        let keyValues = params.keys.map { $0 + "=" + (params[$0] ?? "") }
        let str = keyValues.joined(separator: "&")
        return str
    }
}
