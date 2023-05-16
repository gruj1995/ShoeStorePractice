//
//  CategoryCell.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import SnapKit
import UIKit

class CategoryCell: UICollectionViewCell, ConfigurableCell {
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

    func configure(data model: Category) {
//        categoryImageView.loadImage(
//            with: category.imageUrl,
//            placeholder: UIImage(named: "women")
//        )
        categoryImageView.image = UIImage(named: "women")
        titleLabel.text = model.data?.name ?? ""
    }

    // MARK: Private

    private lazy var gradient: CAGradientLayer = getYGGradientLayer()

    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .appColor(.black)
        label.numberOfLines = 0
        return label
    }()

    private func setupUI() {
        backgroundColor = .appColor(.white)
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.insertSublayer(gradient, at: 0)
        setupLayout()
    }

    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalToSuperview()
        }

        addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
