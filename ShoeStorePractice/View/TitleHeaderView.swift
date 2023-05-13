//
//  TitleHeaderView.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import SnapKit
import UIKit

// MARK: - TitleHeaderView

final class TitleHeaderView: UITableViewHeaderFooterView {
    // MARK: Lifecycle

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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

    var onSeeMoreButtonTapped: ((UIButton) -> Void)?

    func configure(title: String) {
        titleLabel.text = title
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
        contentView.backgroundColor = .appColor(.white)
        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(seeMoreButton)
        seeMoreButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(21)
        }
    }

    @objc
    private func seeMoreButtonTapped(_ sender: UIButton) {
        onSeeMoreButtonTapped?(sender)
    }
}
