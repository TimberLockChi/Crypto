//
//  Double.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/11.
//

import Foundation

extension Double{
    
    
    /// 将Double转化为2位小数，表示货币
    /// ```
    /// Covert 1234.56 to $1,234.56
    /// Covert 12.356 to $12.3456
    /// ```
    private var currencyFormatter2: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true//位数分隔符
        formatter.numberStyle = .currency//货币风格格式
        formatter.locale = .current
        formatter.currencyCode = "usd"//默认值可以更改进行定制
        formatter.currencySymbol = "$"//默认值可以更改进行定制
        //2-6位小数
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    ///将Double转化为字符串
    func asCurrencyWith2Decimals()->String{
        let number = NSNumber(value: self)//将自身转换为NSNumber
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    
    /// 将Double转化为2-6位小数，表示货币
    /// ```
    /// Covert 1234.56 to $1,234.56
    /// Covert 12.356 to $12.3456
    /// ```
    private var currencyFormatter6: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true//位数分隔符
        formatter.numberStyle = .currency//货币风格格式
        formatter.locale = .current
        formatter.currencyCode = "usd"//默认值可以更改进行定制
        formatter.currencySymbol = "$"//默认值可以更改进行定制
        //2-6位小数
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    ///将Double转化为字符串
    func asCurrencyWith6Decimals()->String{
        let number = NSNumber(value: self)//将自身转换为NSNumber
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    ///将Double转化为2位字符串
    func asNumberString()->String{
        return String(format: "%.2f", self)
    }
    ///将Double转化为2位字符串,并加百分号
    func asPercentString()->String{
        return asNumberString() + "%"
    }
    
    func formattedWithAbbreviations()->String{
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        
        switch num{
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()
        default:
            return "\(sign)\(self)"
        }
        
    }
    
}
