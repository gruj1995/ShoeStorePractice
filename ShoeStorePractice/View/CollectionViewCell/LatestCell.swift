//
//  LatestCell.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import SnapKit
import UIKit

// MARK: - LatestCell

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

    func configure(data model: LatestShoeInfo) {
        categoryImageView.loadImage(
            with: model.imageUrl,
            placeholder: UIImage()
        )
        isLike = model.isLike
    }

    func updateLikeButton(isLike: Bool) {
        let image = isLike ? AppImages.heartFill : AppImages.heartEmpty
        let color: UIColor? = isLike ? .orange: .appColor(.gray2)
        likeButton.setImage(image, for: .normal)
        likeButton.tintColor = color
    }

    // MARK: Private

    private var isLike: Bool = false {
        didSet {
            updateLikeButton(isLike: isLike)
        }
    }

    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.touchEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()

    private func setupUI() {
        backgroundColor = .appColor(.gray3)
        clipsToBounds = true
        layer.cornerRadius = 10
        updateLikeButton(isLike: false)
        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().inset(11)
            make.trailing.equalToSuperview().inset(15)
        }

        contentView.addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview().inset(14)
        }
    }

    // TODO: 待修改
    @objc
    private func likeButtonTapped(_ sender: UIButton) {
        isLike.toggle()
    }
}
