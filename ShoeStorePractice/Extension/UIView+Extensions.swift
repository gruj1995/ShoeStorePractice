//
//  UIView+Extensions.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import UIKit

extension UIView {
    func getYGGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let color1 = UIColor(hex: "ECCD5F").cgColor
        let color2 = UIColor(hex: "C5FF7B").cgColor
        gradient.colors = [color1, color2]
        // 漸層比例
        gradient.locations = [0.1139, 1.3853]
        gradient.frame = bounds
        return gradient
    }
}
