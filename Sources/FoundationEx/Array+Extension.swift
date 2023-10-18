//
//  Array+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

extension Array {
    public static func count(_ array: Array?) -> Int{
        guard let array = array else { return 0 }
        return array.count
    }
    
}

extension Array {
    public var stringLiteral: String {
        var string = ""
        for (index, element) in self.enumerated() {
            if index == count - 1 {
                string += "\(element)"
            } else {
                string += "\(element),"
            }
        }
        return string
    }

    public static func containSameElements<T: Comparable & Hashable>(lhs: [T], rhs: [T]) -> Bool {
        let contained = Set(lhs).intersection(Set(rhs))
        return !contained.isEmpty
    }

    public static func isNoElement(_ array: [Any]?) -> Bool {
        guard let array = array else {
            return true
        }
        return array.isEmpty
    }
}

func checkArrayHasElement(_ array: [Any]?) -> Bool {
    return array != nil && !array!.isEmpty
}


extension Array {
    public mutating func mutatingForEach(_ transform:(inout Element) -> ()) {
        for i in 0..<count {
            transform(&self[i])
        }
    }
    
    @discardableResult
    public mutating func mutatingMap<T>(_ transform:(inout Element) -> T) -> [T] {
        var store = [T]()
        for i in 0..<count {
            store.append(transform(&self[i]))
        }
        return store
    }
    
    @discardableResult
    public mutating func appending(_ newElement: Element) -> [Element] {
        self.append(newElement)
        return self
    }
    
    @discardableResult
    public mutating func appending(contentOf: [Element]) -> [Element] {
        self.append(contentsOf: contentOf)
        return self
    }
}

extension Array where Element: Hashable {
    
    public func removeDuplicates() -> Array {
        return Array(Set<Element>(self))
    }
}

extension Array where Element: Equatable {
    
    mutating func removeVC(_ targetVC: Element) {
        self.remove { vc in
            vc == targetVC
        }
    }
    
    public mutating func remove(_ predicate:(Element) -> Bool) {
        let toRemove = filter { (ele) -> Bool in
            return predicate(ele)
        }
        toRemove.forEach { (remove) in
            for i in 0..<count {
                if self[i] == remove {
                    _ = self.remove(at: i)
                    break
                }
            }
        }
    }
    
    public func split(elementCount: Int) -> [[Element]] {
        if self.count == elementCount {
            return [self]
        }
        
        var slice = [[Element]]()
        for i in 0...self.count {
            let min = i * elementCount
            let max = min + elementCount
            if max > self.count {
                slice.append(self[min..<self.count].compactMap { $0 })
                return slice
            }
            slice.append(self[min..<max].compactMap { $0 })
        }
        return slice
    }
}

extension Array where Element: ExpressibleByIntegerLiteral {

    public func joined(separator: String = ",") -> String {

        let content = self.compactMap { (integer) -> String? in
            return String(describing: integer)
        }

        return content.joined(separator: separator)
    }
}

extension Sequence {
    public func group<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
        var groups: [GroupingType: [Iterator.Element]] = [:]
        var groupsOrder: [GroupingType] = []
        forEach { element in
            let key = key(element)
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
                groupsOrder.append(key)
            }
        }
        return groupsOrder.map { groups[$0]! }
    }
}

extension Sequence {
    public func toJson() -> String {
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
}

extension Array where Element == (String, String) {
    public func toDictionary() -> [String: String] {
        Dictionary(uniqueKeysWithValues: self)
    }
}
