//
//  TitleHeaderView.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/14.
//

import SnapKit
import UIKit

class TitleHeaderView: UICollectionReusableView {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    class var reuseId: String {
        return String(describing: self)
    }

    var onSeeMoreButtonTapped: ((UIButton) -> Void)?

    func configure(title: String, showSeeMoreButton: Bool) {
        titleLabel.text = title
        seeMoreButton.isHidden = !showSeeMoreButton
    }

    // MARK: Private

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .left
        label.textColor = .appColor(.black)
        return label
    }()

    private lazy var seeMoreButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(top: 3, leading: 10, bottom: 3, trailing: 10)
        config.attributedTitle = AttributedString("See more", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold)]))
        config.titleAlignment = .center
        config.baseBackgroundColor = .appColor(.darkGray2)
        config.baseForegroundColor = .appColor(.white) // 圖片及文字顏色
        config.cornerStyle = .capsule
        button.configuration = config

        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
        return button
    }()

    private func setupUI() {
        backgroundColor = .clear
        setupLayout()
    }

    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }

        addSubview(seeMoreButton)
        seeMoreButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.trailing.centerY.equalToSuperview()
            make.height.equalTo(21)
        }
    }

    @objc
    private func seeMoreButtonTapped(_ sender: UIButton) {
        onSeeMoreButtonTapped?(sender)
    }
}
