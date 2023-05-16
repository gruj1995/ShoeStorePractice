//
//  BrandInfoCell.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import SnapKit
import UIKit

class BrandInfoCell: UICollectionViewCell, ConfigurableCell {
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

    override func layoutSubviews() {
        super.layoutSubviews()
        cartButton.layer.cornerRadius = cartButton.frame.height * 0.5
        cartButtonGradientLayer.frame = cartButton.bounds
    }

    func configure(data brand: Brand?) {
        categoryImageView.image = AppImages.shoesBig
        brandLabel.text = brand?.title ?? ""
    }

    // MARK: Private

    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor(.darkGray2)
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()

    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [brandLabel, cartButton])
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.alignment = .center
        return stackView
    }()

    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .appColor(.white)
        return label
    }()

    private lazy var cartButtonGradientLayer: CAGradientLayer = getYGGradientLayer()

    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.appColor(.black), for: .normal)
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.layer.insertSublayer(cartButtonGradientLayer, at: 0)
        return button
    }()

    private func setupUI() {
        backgroundColor = .appColor(.white)
        setupLayout()
    }

    private func setupLayout() {
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(18)
        }

        bgView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(25)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.centerY.equalToSuperview()
        }

        cartButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 92, height: 27))
        }

        addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
            make.leading.equalTo(infoStackView.snp.trailing).offset(5)
            make.trailing.top.bottom.equalToSuperview()
        }
    }
}
