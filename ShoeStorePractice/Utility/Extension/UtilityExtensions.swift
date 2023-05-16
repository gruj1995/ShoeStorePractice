//
//  UtilityExtensions.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import UIKit
import Kingfisher

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

extension UIImageView {
    func loadImage(with url: URL?, placeholder: UIImage? = nil) {
        kf.setImage(with: url, placeholder: placeholder)
    }
}
