//
//  CollectionViewContainerCell.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import SnapKit
import UIKit

// MARK: - CollectionViewData

protocol CollectionViewData: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {}

// MARK: - CollectionViewContainerCell

class CollectionViewContainerCell: UITableViewCell {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    // MARK: Internal

    class var reuseIdentifier: String {
        return String(describing: self)
    }

    func configure(_ dataSourceDelegate: CollectionViewData) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.reloadData()
    }

    // MARK: Private

    private let itemSize: CGSize = .init(width: 148, height: 82)

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14 // 左右間隔
        layout.minimumInteritemSpacing = 0
        layout.itemSize = itemSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GradientBackgroundCell.self, forCellWithReuseIdentifier: GradientBackgroundCell.reuseIdentifier)
        collectionView.backgroundColor = .appColor(.white)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private func setupUI() {
        contentView.backgroundColor = .appColor(.white)
        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(itemSize.height)
        }
    }
}
