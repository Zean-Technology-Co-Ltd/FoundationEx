//
//  UIScreen+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

extension UIApplication {
    public var nn_keyWindow: UIWindow? {
        if #available(iOS 14.0, *) {
            if let window = UIApplication.shared.connectedScenes.map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.first {
                return window
            } else if let window = UIApplication.shared.delegate?.window {
                return window
            } else {
                return nil
            }
        } else if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first{
                return window
            } else if let window = UIApplication.shared.delegate?.window {
                return window
            } else {
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window {
                return window
            }else{
                return nil
            }
        }
    }
}

extension UIScreen {
    
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    public class var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    public static var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    public static var isIphoneX: Bool {
        if #available(iOS 13.0, *){
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return false }
            guard let window = windowScene.windows.first else { return false }
            return window.safeAreaInsets.bottom > 0
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.keyWindow else {
                return false
            }
            return window.safeAreaInsets.bottom > 0
        } else {
            return false
        }
    }
    
    public static var safeAreaTopPadding: CGFloat {
        return UIScreen.isIphoneX ? 44:20
    }
    
    public static var safeAreaBottomPadding: CGFloat {
        return UIScreen.isIphoneX ? 34:0
    }
    
    public static var navBarHeight: CGFloat {
        return safeAreaTopPadding + 44;
    }
    
    public static var tabBarHeight: CGFloat {
        return safeAreaBottomPadding + 49;
    }
}

private let iphone6Width: CGFloat = 390
private let ScreenWidth = UIScreen.screenWidth
private let ScreenHeight = UIScreen.screenHeight
extension CGFloat{
    public func rpx() -> CGFloat {
        return CGFloat(self)*(ScreenWidth / iphone6Width)
    }
    
    // 向上取整
    public func crpx() -> CGFloat {
        return ceil(CGFloat(self)*(ScreenWidth / iphone6Width))
    }
    
    public func cpx() -> CGFloat {
        return ceil(self)
    }
    // 向下取整
    public func frpx() -> CGFloat {
        return floor((self)*(ScreenWidth / iphone6Width))
    }
    
    public func fpx() -> CGFloat {
        return floor(self)
    }
}

extension Int{
    public func rpx() -> CGFloat {
        return CGFloat(self)*(ScreenWidth / iphone6Width)
    }
}


extension Double{
    public func rpx() -> CGFloat {
        return CGFloat(self)*(ScreenWidth / iphone6Width)
    }
    // 向上取整
    public func crpx() -> CGFloat {
        return ceil(CGFloat(self)*(ScreenWidth / iphone6Width))
    }
    public func cpx() -> CGFloat {
        return ceil(self)
    }
    
    // 向下取整
    public func frpx() -> CGFloat {
        return floor((self)*(ScreenWidth / iphone6Width))
    }
    
    public func fpx() -> CGFloat {
        return floor(self)
    }
    
    public static var screenWidth: Double{
        return UIScreen.screenWidth
    }
    
    public static var screenHeight: Double{
        return UIScreen.screenHeight
    }
}

