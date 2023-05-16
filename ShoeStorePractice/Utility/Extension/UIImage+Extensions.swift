//
//  UIImage+Extensions.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/16.
//

import UIKit
import CoreImage

extension UIImage {
    func removeBackground() -> UIImage? {
        guard let ciImage = CIImage(image: self) else {
            return nil
        }

        // 创建一个去背滤镜
        let filter = CIFilter(name: "CIMaskToAlpha")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)

        // 获取输出图像
        guard let outputImage = filter?.outputImage else {
            return nil
        }

        // 将输出图像转换为 UIImage
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }

        let resultImage = UIImage(cgImage: cgImage)
        return resultImage
    }

}
