//
//  BrandCell.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/14.
//

import SnapKit
import UIKit

class BrandCell: UICollectionViewCell, ConfigurableCell {
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

    func configure(data model: Brand) {
        categoryImageView.image = UIImage(named: model.rawValue)
    }

    // MARK: Private

    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()

    private func setupUI() {
        backgroundColor = .appColor(.white)
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = UIColor.appColor(.black)?.cgColor
        layer.borderWidth = 1
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
