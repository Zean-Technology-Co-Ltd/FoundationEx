//
//  NSObject+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//
import UIKit

public protocol AssociatedObjectStore {}

public extension AssociatedObjectStore {
    func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
        let temp = objc_getAssociatedObject(self, key) as? T
        return temp
    }
    
    func associatedObject<T>(forKey key: UnsafeRawPointer, default: @autoclosure () -> T) -> T {
        if let optional: T? = self.associatedObject(forKey: key), let object: T = optional {
            return object
        }
        let object = `default`()
        self.setAssociatedObject(object, forKey: key)
        return object
    }
    
    func setAssociatedObject<T>(_ object: T?, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}


public protocol Swizzling: AnyObject {
    static func awake()
    static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector)
}

public extension Swizzling {
    static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        guard (originalMethod != nil && swizzledMethod != nil) else {
            return
        }
        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}

public extension NSObject {
    static var className: String {
        return String(describing: self)
    }

    static var typeWithNamespace: String {
        return String(reflecting: self)
    }

    var typeWithNamespace: String {
        return String(reflecting: type(of: self))
    }
    
    static func queryParameters(for url: URL?) -> [String: String] {
        url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: true) }?
            .queryItems?
            .compactMap { item in
                item.value?.removingPercentEncoding.flatMap { (item.name, $0) }
            }
            .toDictionary() ?? [:]
    }

    static func modelToData<T: Codable>(model: T) -> Data? {
        do {
            let data = try JSONEncoder().encode(model)
            return data
        } catch {
            return nil
        }
    }
    
    /// Data转字典/数组
    static func dataToObject(_ data: Data) -> Any? {
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            return object
        } catch {
            return nil
        }
    }
    
    static func dataToArray(_ data: Data?) -> [[String: Any]]? {
        guard let data = data else { return nil }
        let array = dataToObject(data) as! [[String: Any]]
        return array
    }
    
    static func dataToDictionary(data:Data?) ->Dictionary<String, Any>?{
        guard let data = data else { return nil }
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            return dic
        }catch _ {
            return nil
        }
    }
}

extension NSObject{
    public var topmostViewController: UIViewController?{
        let topViewController = UIApplication.shared.nn_keyWindow?.rootViewController

        guard var topViewController = topViewController else { return nil }

        while (true) {
            if topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            } else if topViewController is UINavigationController {
                let navi = topViewController as! UINavigationController
                topViewController = navi.topViewController!
            } else if topViewController is UITabBarController {
                let tab = topViewController as! UITabBarController
                topViewController = tab.selectedViewController!
            } else {
                break
            }
        }
        
        return topViewController
    }
    
    public static var topmostViewController: UIViewController?{
        let topViewController = UIApplication.shared.nn_keyWindow?.rootViewController

        guard var topViewController = topViewController else { return nil }

        while (true) {
            if topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            } else if topViewController is UINavigationController {
                let navi = topViewController as! UINavigationController
                topViewController = navi.topViewController!
            } else if topViewController is UITabBarController {
                let tab = topViewController as! UITabBarController
                topViewController = tab.selectedViewController!
            } else {
                break
            }
        }
        
        return topViewController
    }
}


public protocol JsonStringRepresentable {
    var jsonString: String { get }
}
extension JsonStringRepresentable {
    var jsonString: String { return String(describing: self) }
}

extension Int: JsonStringRepresentable {
    public var jsonString: String { return "\(self)" }
}
extension UInt: JsonStringRepresentable {
    public var jsonString: String { return "\(self)" }
}
extension Float: JsonStringRepresentable {
    public var jsonString: String { return "\(self)" }
}
extension Double: JsonStringRepresentable {
    public var jsonString: String { return "\(cleanString)" }
}
extension String: JsonStringRepresentable {
    public var jsonString: String { return self }
}
