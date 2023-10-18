//
//  Date+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import Foundation

extension Date {
    /// yyyy-MM-dd HH:mm:ss
    public static let fullFormatter: DateFormatter = {
        return InitFormatter("yyyy-MM-dd HH:mm:ss")
    }()
    /// yyyy-MM-dd hh:mm
    public static let formatterTillMinute: DateFormatter = {
        return InitFormatter("yyyy-MM-dd hh:mm")
    }()
    /// HH:mm
    public static let formatterOnlyTime: DateFormatter = {
        return InitFormatter("HH:mm")
    }()
    
    public static let formatterForYear: DateFormatter = {
        return InitFormatter("yyyy")
    }()
    
    public static let monthFormatter: DateFormatter = {
        return InitFormatter("yyyy-MM-dd")
    }()
    
    public static let yearFormatter: DateFormatter = {
        return InitFormatter("yyyy-MM")
    }()
    /// MM月dd日
    public static let formatterMonth: DateFormatter = {
        return InitFormatter("MM月dd日")
    }()
    /// yyyy.MM.dd
    public static let formatterWithPoint: DateFormatter = {
        return InitFormatter("yyyy.MM.dd")
    }()
    
    public static let formatterWithSlash: DateFormatter = {
        return InitFormatter("yyyy/MM/dd")
    }()
    
    static let formatterForAttachment: DateFormatter = {
        return InitFormatter("yyyyMMddHHmm")
    }()
    
    private static func InitFormatter(_ dateFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }
    
    public func fullString() -> String {
        return Date.fullFormatter.string(from: self)
    }
    
    public func onlyDateString() -> String {
        return Date.formatterWithSlash.string(from: self)
    }
    
    public func onlyTimeString() -> String {
        return Date.formatterOnlyTime.string(from: self)
    }
    
    public func dateString() -> String {
        return Date.monthFormatter.string(from: self)
    }
    
    public func dateString(_ formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
    
    func stringWithFormat(_ formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
    
    public static func initFromCreamsTimestamp(_ milliTimestamp: UInt64?) -> Date? {
        guard let timestamp = milliTimestamp else {
            return nil
        }
        return Date(timeIntervalSince1970: TimeInterval(timestamp / 1_000))
    }
    
    public static func initFromCreamsTimestamp(_ milliTimestamp: UInt64) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(milliTimestamp / 1_000))
    }
}

extension Date {
    public static var todayTimestamp: UInt64 {
        return UInt64(Date().timeIntervalSince1970 * 1_000)
    }
}

extension Date {
    
    public static var todayString: String {
        return Date().dateString()
    }
    
    public static var yesterdayString: String {
        return Date().addingTimeInterval(-(24 * 60 * 60)).dateString()
    }
    
    public static var thisWeekBeginDayString: String {
        return Date().weekBeginDay.dateString()
    }
    
    public static var thisWeekEndDayString: String {
        return Date().weekEndDay.dateString()
    }
    
    public static var thisMonthBeginDayString: String {
        return Date().monthBeginDay.dateString()
    }
    
    public static var thisMonthEndDayString: String {
        return Date().monthEndDay.dateString()
    }
    
    public static var thisYearBeginString: String {
        return Date().yearBeginDay.dateString()
    }
    
    public static var thisYearEndString: String {
        return Date().yearEndDay.dateString()
    }
}

extension Date {
    
    private static let iso8601Calendar = Calendar(identifier: .iso8601)
    
    public var weekBeginDay: Date {
        let calendar = Date.iso8601Calendar
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        let date = calendar.date(from: components)!
        return date
    }
    
    public var weekEndDay: Date {
        return Calendar.current.date(byAdding: .second, value: 604_799, to: weekBeginDay)!
    }
    
    public var monthBeginDay: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self))
        let date = calendar.date(from: components)!
        return date
    }
    
    public var monthEndDay: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: monthBeginDay)!
    }
    
    public static var oneDaymSecond: Int {
        return 86_400_000
    }
    
    public var yearBeginDay: Date {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(Set<Calendar.Component>([.year]), from: date)
        let startOfYear = calendar.date(from: components)!
        return startOfYear
    }
    
    public var yearEndDay: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 1
        //        let returnEndTime = false
        if false {
            //            components.second = -1
        } else {
            components.day = -1
        }
        
        let endOfYear = calendar.date(byAdding: components, to: yearBeginDay)!
        return endOfYear
    }
}

public extension Date {
    
    func plus(seconds s: UInt) -> Date {
        return addComponentsToDate(seconds: Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    func minus(seconds s: UInt) -> Date {
        return addComponentsToDate(seconds: -Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    func plus(minutes m: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    func minus(minutes m: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: -Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    func plus(hours h: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: 0, hours: Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    func minus(hours h: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: 0, hours: -Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    func plus(days d: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: Int(d), weeks: 0, months: 0, years: 0)
    }
    
    func minus(days d: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: -Int(d), weeks: 0, months: 0, years: 0)
    }
    
    func plus(weeks w: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: Int(w), months: 0, years: 0)
    }
    
    func minus(weeks w: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: -Int(w), months: 0, years: 0)
    }
    
    func plus(months m: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: Int(m), years: 0)
    }
    
    func minus(months m: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: -Int(m), years: 0)
    }
    
    func plus(years y: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: Int(y))
    }
    
    func minus(years y: UInt) -> Date {
        return addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: -Int(y))
    }
    
    fileprivate func addComponentsToDate(seconds sec: Int,
                                         minutes min: Int,
                                         hours hrs: Int,
                                         days d: Int,
                                         weeks wks: Int,
                                         months mts: Int,
                                         years yrs: Int) -> Date {
        var components = DateComponents()
        components.second = sec
        components.minute = min
        components.hour = hrs
        components.day = d
        components.weekOfYear = wks
        components.month = mts
        components.year = yrs
        components.timeZone = TimeZone.current
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func midnightUTCDate() -> Date {
        var components: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        components.timeZone = TimeZone.current
        return Calendar.current.date(from: components)!
    }
    
    static func secondsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        var components = Calendar.current.dateComponents([.second], from: d1, to: d2)
        components.timeZone = TimeZone.current
        return components.second!
    }
    
    static func minutesBetween(date1 d1: Date, date2 d2: Date) -> Int {
        var components = Calendar.current.dateComponents([.minute], from: d1, to: d2)
        components.timeZone = TimeZone.current
        return components.minute!
    }
    
    static func hoursBetween(date1 d1: Date, date2 d2: Date) -> Int {
        var components = Calendar.current.dateComponents([.hour], from: d1, to: d2)
        components.timeZone = TimeZone.current
        return components.hour!
    }
    
    static func daysBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: d1) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: d2) else {
            return 0
        }
        return end - start
    }
    
    static func weeksBetween(date1 d1: Date, date2 d2: Date) -> Int {
        var components = Calendar.current.dateComponents([.weekOfYear], from: d1, to: d2)
        components.timeZone = TimeZone.current
        return components.weekOfYear!
    }
    
    static func monthsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        var components = Calendar.current.dateComponents([.month], from: d1, to: d2)
        components.timeZone = TimeZone.current
        return components.month!
    }
    
    static func yearsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        var components = Calendar.current.dateComponents([.year], from: d1, to: d2)
        components.timeZone = TimeZone.current
        return components.year!
    }
    
    /// 两个日期之间天数差转换为多少年 多少月 多少日
    ///
    /// - Parameters:
    ///   - d1: 第一个日期 eg 2018/7/18
    ///   - d2: 第二个日期 eg 2019/8/19
    /// - Returns: 13个月1天
    static func daysBetweenTwoDateConvertToYearMonthDay(date1 d1: Date, date2 d2: Date) -> String {
        let dayNumber = Date.daysBetween(date1: d1, date2: d2) + 1
        
        let monthString: String = dayNumber >= 30 ? "\(dayNumber / 30)个月" : ""
        let dayString: String = "\(dayNumber - (dayNumber / 30) * 30)天"
        
        
        let timeString = monthString + dayString
        return timeString
    }
    //MARK- Comparison Methods
    
    func isGreaterThan(_ date: Date) -> Bool {
        return (compare(date) == .orderedDescending)
    }
    
    func isLessThan(_ date: Date) -> Bool {
        return (compare(date) == .orderedAscending)
    }
    
    //MARK- Computed Properties
    
    var day: UInt {
        return UInt(Calendar.current.component(.day, from: self))
    }
    
    var month: UInt {
        return UInt(NSCalendar.current.component(.month, from: self))
    }
    
    var year: UInt {
        return UInt(NSCalendar.current.component(.year, from: self))
    }
    
    var hour: UInt {
        return UInt(NSCalendar.current.component(.hour, from: self))
    }
    
    var minute: UInt {
        return UInt(NSCalendar.current.component(.minute, from: self))
    }
    
    var second: UInt {
        return UInt(NSCalendar.current.component(.second, from: self))
    }
    
    var isToday: Bool {
        let today = Date()
        return today.day == day && today.month == month && today.year == year
    }
    
    var isYesterday: Bool {
        let yesterday = Date().addingTimeInterval(-(24 * 60 * 60))
        return yesterday.day == day && yesterday.month == month && yesterday.year == year
    }
    
    var isTheDayBeforeYesterday: Bool {
        let theDayBeforeYesterday = Date().addingTimeInterval(-(24 * 60 * 60 * 2))
        return theDayBeforeYesterday.day == day && theDayBeforeYesterday.month == month && theDayBeforeYesterday.year == year
    }
    
    var isThisWeek: Bool {
        let begin = Date().weekBeginDay
        let end = Date().weekEndDay
        return begin <= self && self <= end
    }
    
    var isThisMonth: Bool {
        let begin = Date().monthBeginDay
        let end = Date().monthEndDay
        return begin <= self && self <= end
    }
    
    var isThisYear: Bool {
        let begin = Date().year
        let end = self.year
        return begin == end
    }
}

public extension Date {
    func changDateFormatter(_ to: DateFormatter) -> String? {
        return to.string(from: self)
    }
    
    static func timeIntervalToString(timeInterval: TimeInterval) -> String{
        //如果服务端返回的时间戳精确到毫秒，需要除以1000,否则不需要
        let date: Date = Date.init(timeIntervalSince1970: timeInterval/1000)
        let formatter = DateFormatter.init()
        let minutesBetween = self.minutesBetween(date1: date, date2: Date())
        
//        if minutesBetween < 30 {
//            return "\(minutesBetween == 0 ? 1: minutesBetween)" + "分钟前"
//        } else
        if date.isToday == true {
            //是今天
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date as Date)
            
        }
//        else if date.isYesterday == true {
//            //是昨天
//            formatter.dateFormat = "昨天 HH:mm"
//            return formatter.string(from: date as Date)
//        }else if date.isThisWeek == true{
//            //是同一周
//            let week = date.weekdayStringFromDate()
//            formatter.dateFormat = "\(week) HH:mm"
//            return formatter.string(from: date as Date)
//        }
        else if date.isThisYear{
            formatter.dateFormat = "MM月dd日"
            return formatter.string(from: date as Date)
        } else {
            formatter.dateFormat = "yyyy年MM月dd日"
            return formatter.string(from: date as Date)
        }
    }
    
    private func weekdayStringFromDate() -> String {
        let weekdays:NSArray = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar.init(identifier: .gregorian)
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: self as Date)
        return weekdays.object(at: theComponents.weekday!) as! String
    }
}

open class DataTool: NSObject {
    class func timeIntervalToString(timeInterval: TimeInterval) -> String {
        return Date.timeIntervalToString(timeInterval: timeInterval)
    }
    
    class func timeIntervalToString(time: String) -> String {
        print(Date.formatterTillMinute.dateFormat as Any)
        let timeInterval = time.dateToTimeStamp(formatter: Date.formatterTillMinute)
        return Date.timeIntervalToString(timeInterval: Double(timeInterval))
    }
}

