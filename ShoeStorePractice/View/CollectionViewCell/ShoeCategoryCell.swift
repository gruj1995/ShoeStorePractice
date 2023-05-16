//
//  ShoeCategoryCell.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import SnapKit
import UIKit

class ShoeCategoryCell: UICollectionViewCell, ConfigurableCell {
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

    func configure(data model: ShoeCategory) {
        categoryLabel.text = model.title
        categoryLabel.textColor = model.isSelected ? .appColor(.white) : .appColor(.black)
        categoryLabel.backgroundColor = model.isSelected ? .appColor(.darkGray2) : .appColor(.white)
    }

    // MARK: Private

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
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
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

//    override var isSelected: Bool {
//        didSet {
//            categoryLabel.textColor = isSelected ? .appColor(.white) : .appColor(.black)
//            categoryLabel.backgroundColor = isSelected ? .appColor(.darkGray2) : .appColor(.white)
//        }
//    }
}
