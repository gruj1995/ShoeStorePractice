//
//  DynamicHeightFlowLayout.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import UIKit

class DynamicHeightFlowLayout: UICollectionViewFlowLayout {
    // MARK: Internal
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        var yOffset: CGFloat = 0

        for attributes in layoutAttributes ?? [] {
            if attributes.representedElementCategory == .cell {
                let indexPath = attributes.indexPath
                if let cellHeight = calculateCellHeight(for: indexPath) {
                    attributes.frame.size.height = cellHeight
                }
            }
            yOffset = max(yOffset, attributes.frame.maxY)
        }

        return layoutAttributes
    }

    // MARK: Private

    private func calculateCellHeight(for indexPath: IndexPath) -> CGFloat? {
        // 在此处根据单元格的内容计算高度并返回
        // 返回nil时，将使用flow layout的itemSize属性
        return nil
    }
}
