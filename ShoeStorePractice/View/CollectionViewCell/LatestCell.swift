//
//  LatestCell.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import SnapKit
import UIKit

class LatestCell: UICollectionViewCell, ConfigurableCell {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: Internal

    class var reuseId: String {
        return String(describing: self)
    }

    func configure(data brand: String) {
//        categoryImageView.image = UIImage(named: brand)
        categoryImageView.image = AppImages.shoesSmall
    }

    // MARK: Private

    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()

    private func setupUI() {
        backgroundColor = .appColor(.gray3)
        clipsToBounds = true
        layer.cornerRadius = 10
        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}
