//
//  CellConfigurator.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/14.
//

import UIKit

// MARK: - ConfigurableCell

protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType)
}

// MARK: - CellConfigurator

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
}

// MARK: - CollectionCellConfigurator

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UICollectionViewCell {
    // MARK: Lifecycle

    init(item: DataType) {
        self.item = item
    }

    // MARK: Internal

    static var reuseId: String { return String(describing: CellType.self) }

    let item: DataType

    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
}
