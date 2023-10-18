//
//  NSNumber+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import Foundation

public extension NSNumber {
    var string: String {
        return self.stringValue
    }
}

public extension Int {
    var string: String {
        return "\(self)"
    }
}

public extension Bool {
    var intValue: Int {
        return self == true ? 1 : 0
    }
}

public extension Optional where Wrapped == Int {
    var string: String {
        guard let value = self else {
            return ""
        }
        return "\(value)"
    }
   
}

public extension Double {

    var string: String {
        return "\(self)"
    }

    var cleanString: String {
        guard self != 0 else { return "0" }
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

public extension Double {
  
    fileprivate func positiveString(round: Int) -> String {
        if self == 0 {
            return String(format:"%.\(round)f", roundTo(places: round))
        }

        var positiveFormat = ",###"
        
        if round > 0 {
            positiveFormat += "."
        }
        
        for _ in 0..<round {
            positiveFormat += "0"
        }
        
        let num = NSNumber(value: self)
        let format = NumberFormatter()
        format.positiveFormat = positiveFormat
        var formatStr = format.string(from: num) ?? "-"
        if (self < 1.0 && self > 0) || formatStr.hasPrefix(".") {
            formatStr = "0" + formatStr
        }
        return formatStr
    }
    

    var noDecimalString: String {
        return positiveString(round: 0)
    }

    var oneDecimalString: String {
         return positiveString(round: 1)
    }

    var twoDecimalString: String {
        return positiveString(round: 2)
    }

    func toPercentString(round: Int) -> String {
        return (self * 100.0).positiveString(round:round) + "%"
    }

    func roundTo(places: Int) -> Double {
        guard self != 0 else {
            return 0
        }

        let divisor = pow(10.0, Double(places))
        let rounded = (self * divisor).rounded()

        return rounded / divisor
    }
}

public extension Optional where Wrapped == Double {

    var noDecimalString: String {

        guard let value = self else {
            return ""
        }

        return value.noDecimalString
    }

    var oneDecimalString: String {

        guard let value = self else {
            return ""
        }

        return value.oneDecimalString
    }

    var twoDecimalString: String {

        guard let value = self else {
            return "-"
        }

        return value.twoDecimalString
    }
    
    var twoDecimalIfNilReturnZeroString: String {
        guard let value = self else {
            return Double(0).twoDecimalString
        }
        
        return value.twoDecimalString
    }

    func roundTo(places: Int) -> Double {

        guard let value = self else {
            return 0
        }

        return value.roundTo(places: places)
    }
}
