//
//  UIColor+Extensions.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import UIKit

// MARK: - AssetsColor

enum AssetsColor {
    case black
    case white
    case gray1
    case gray2
    case gray3
    case darkGray1
    case darkGray2
    case green
    case yellow
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .black: return UIColor(named: "black")
        case .white: return UIColor(named: "white")
        case .gray1: return UIColor(named: "gray1")
        case .gray2: return UIColor(named: "gray2")
        case .gray3: return UIColor(named: "gray3")
        case .darkGray1: return UIColor(named: "darkGray1")
        case .darkGray2: return UIColor(named: "darkGray2")
        case .green: return UIColor(named: "green")
        case .yellow: return UIColor(named: "yellow")
        }
    }
}

extension UIColor {
    func toHexString() -> String {
        var rValue: CGFloat = 0
        var gValue: CGFloat = 0
        var bValue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&rValue, green: &gValue, blue: &bValue, alpha: &alpha)

        let rgb = Int(rValue * 255)<<16 | Int(gValue * 255)<<8 | Int(bValue * 255)<<0

        return String(format: "#%06x", rgb)
    }

    /// 用16進制色碼生成顏色，前面可帶入#符號
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue: UInt64 = 0 // color #999999 if string has wrong format

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) == 6 {
            Scanner(string: cString).scanHexInt64(&rgbValue)
        }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
