//
//  PopularCell.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import SnapKit
import UIKit

class PopularCell: UICollectionViewCell, ConfigurableCell {
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

    func configure(data model: ShoeInfo) {
        categoryImageView.loadImage(
            with: model.imageUrl,
            placeholder: AppImages.shoesBig
        )
//        categoryImageView.image = categoryImageView.image?.removeBackground()
        nameLabel.text = model.brand
        descriptionLabel.text = model.description
        amountLabel.text = model.amountString
    }

    // MARK: Private

    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor(.gray3)
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()

    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, amountLabel])
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .appColor(.black)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 19, weight: .medium)
        label.textColor = .appColor(.black)?.withAlphaComponent(0.3)
        return label
    }()

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .appColor(.black)
        return label
    }()


    private func setupUI() {
        backgroundColor = .appColor(.white)
        setupLayout()
    }

    private func setupLayout() {
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.top.bottom.equalToSuperview().inset(10)
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview().inset(20)
        }

        bgView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(25)
            make.width.equalToSuperview().multipliedBy(0.33)
            make.centerY.equalToSuperview()
        }

        bgView.addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
            make.leading.equalTo(infoStackView.snp.trailing)
            make.trailing.top.bottom.equalToSuperview().inset(5)
        }
    }
}
