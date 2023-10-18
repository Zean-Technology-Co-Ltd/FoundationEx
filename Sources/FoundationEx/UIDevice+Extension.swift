//
//  UIDevice+Extension.swift
//  NiuNiuRent
//
//  Created by Q Z on 2023/7/4.
//

import UIKit
import MachO

extension UIDevice{
    public static var bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    public static var appName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
    public static var localVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    /// 获取电量
    public static func getBatteryLevel() -> Float {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return UIDevice.current.batteryLevel
    }
    
    /// 获取电池的状态 0充电中 1放电中 2已充满 3未知状态
    public static func getBatteryState() -> Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        switch UIDevice.current.batteryState {
        case .unplugged:
            return 1
        case .charging:
            return 0
        case .full:
            return 2
        case .unknown:
            return 3
        @unknown default:
            return 3
        }
    }
    
    public static func canOpenAppList() -> [[String: String]] {
        var params = [["name": "QQ", "urlScheme": "mqq", "state": "0", "appType": "iOS"],
                      ["name": "微信", "urlScheme": "weixin", "state": "0", "appType": "iOS"],
                      ["name": "支付宝", "urlScheme": "alipay", "state": "0", "appType": "iOS"],
                      ["name": "淘宝", "urlScheme": "taobao", "state": "0", "appType": "iOS"],
                      ["name": "京东", "urlScheme": "openapp.jdmobile", "state": "0", "appType": "iOS"],
                      ["name": "天猫", "urlScheme": "tmall", "state": "0", "appType": "iOS"],
                      ["name": "抖音", "urlScheme": "snssdk1128", "state": "0", "appType": "iOS"],
                      ["name": "百度地图", "urlScheme": "baidumap", "state": "0", "appType": "iOS"],
                      ["name": "高德地图", "urlScheme": "iosamap", "state": "0", "appType": "iOS"],
                      ["name": "腾讯地图", "urlScheme": "qqmap", "state": "0", "appType": "iOS"],
                      ["name": "QQ音乐", "urlScheme": "qqmusic", "state": "0", "appType": "iOS"],
                      ["name": "网易音乐", "urlScheme": "orpheus", "state": "0", "appType": "iOS"],
                      ["name": "美团", "urlScheme": "imeituan", "state": "0", "appType": "iOS"],
                      ["name": "大众点评", "urlScheme": "dianping", "state": "0", "appType": "iOS"],
                      ["name": "企业微信", "urlScheme": "wxwork", "state": "0", "appType": "iOS"],
                      ["name": "12306", "urlScheme": "cn.12306", "state": "0", "appType": "iOS"],
                      ["name": "钉钉", "urlScheme": "dingtalk", "state": "0", "appType": "iOS"],
                      ["name": "同花顺", "urlScheme": "amihexin", "state": "0", "appType": "iOS"],
                      ["name": "拼多多", "urlScheme": "pinduoduo", "state": "0", "appType": "iOS"],
                      ["name": "小红书", "urlScheme": "xhsdiscover", "state": "0", "appType": "iOS"],
                      ["name": "快手", "urlScheme": "kwai", "state": "0", "appType": "iOS"],
                      ["name": "新浪微博", "weibo": "sinaweibo", "state": "0", "appType": "iOS"],
                      ["name": "墨迹天气", "urlScheme": "rm434209233MojiWeather", "state": "0", "appType": "iOS"],
                      ["name": "知乎", "urlScheme": "zhihu", "state": "0", "appType": "iOS"],
                      ["name": "网易新闻", "urlScheme": "newsapp", "state": "0", "appType": "iOS"],
                      ["name": "腾讯新闻", "urlScheme": "qqnews", "state": "0", "appType": "iOS"],
                      ["name": "优酷", "urlScheme": "youku", "state": "0", "appType": "iOS"],
                      ["name": "爱奇艺视频", "urlScheme": "qiyi-iphone", "state": "0", "appType": "iOS"],
                      ["name": "哔哩哔哩", "urlScheme": "bilibili", "state": "0", "appType": "iOS"],
                      ["name": "腾讯视频", "urlScheme": "tenvideo", "state": "0", "appType": "iOS"],
                      ["name": "今日头条", "urlScheme": "snssdk141", "state": "0", "appType": "iOS"]
        ]
        for (idx, data) in params.enumerated() {
            var data = data
            let urlScheme = "\(data["urlScheme"] ?? "")://"
            if let url = URL(string: urlScheme) {
                if UIApplication.shared.canOpenURL(url){
                    data["state"] = "1"
                    params[idx] = data
                }
            }
        }
        return params
    }
}

