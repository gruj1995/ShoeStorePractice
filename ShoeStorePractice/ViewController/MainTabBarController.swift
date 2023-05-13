//
//  MainTabBarController.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import SnapKit
import UIKit

// MARK: - MainTabBarController

class MainTabBarController: UITabBarController {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTabBarHeight()
    }

    // MARK: Private

    private let tabBarHeight: CGFloat = Constants.tabBarHeight
    private var appearance = UITabBarAppearance()
    private let imageWidth: CGFloat = 24
    private let underlineWidth: CGFloat = 16
    private var imageVPadding: CGFloat = 0

    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor(.black)
        return view
    }()

    private func setupUI() {
        setTabBarItems()
        setTabBarAppearance()
        addTabBarUnderline()
    }

    private func setTabBarItems() {
        let homeVC = HomeViewController()
        let homeNavVC = createNavigationController(rootViewController: homeVC, image: AppImages.home)

        let walletVC = UIViewController()
        let walletNavVC = createNavigationController(rootViewController: walletVC, image: AppImages.wallet)

        let cartVC = UIViewController()
        let cartNavVC = createNavigationController(rootViewController: cartVC, image: AppImages.cart)

        let userVC = UIViewController()
        let userNavVC = createNavigationController(rootViewController: userVC, image: AppImages.user)

        viewControllers = [homeNavVC, walletNavVC, cartNavVC, userNavVC]
    }

    private func createNavigationController(rootViewController: UIViewController, image: UIImage?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        return navController
    }

    private func setTabBarAppearance() {
        // 頂部圓角
        tabBar.layer.cornerRadius = 15
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.clipsToBounds = true

        // 用螢幕高度判斷型號，調整 icon 位置
        imageVPadding = (Constants.screenHeight > 736) ? 15 : 8
        let insets = UIEdgeInsets(top: imageVPadding, left: 0, bottom: -imageVPadding, right: 0)
        tabBar.items?.forEach { $0.imageInsets = insets }

        // 去除上方分隔線
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundColor = .appColor(.white)
        setTabBarItemColors(appearance.stackedLayoutAppearance)
        setTabBarItemColors(appearance.inlineLayoutAppearance)
        setTabBarItemColors(appearance.compactInlineLayoutAppearance)
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        // tabbar 標籤未被選取時的顏色
        itemAppearance.normal.iconColor = .appColor(.gray1)
        // tabBar 標籤被選取時的顏色
        itemAppearance.selected.iconColor = .appColor(.black)
    }

    // 指定自訂的TabBar高度
    private func adjustTabBarHeight() {
        var tabBarFrame = tabBar.frame
        tabBarFrame.size.height = tabBarHeight
        tabBarFrame.origin.y = view.frame.size.height - tabBarHeight
        tabBar.frame = tabBarFrame
    }

    private func addTabBarUnderline() {
        tabBar.addSubview(underlineView)
        updateUnderlinePosition(animated: false)
    }

    private func updateUnderlinePosition(animated: Bool) {
        let tabBarWidth = tabBar.frame.size.width
        let itemWidth = tabBarWidth / CGFloat(tabBar.items?.count ?? 1)
        let x = itemWidth * CGFloat(selectedIndex) + (itemWidth - underlineWidth) / 2
        // TODO: 26是觀察出的上方inset值，可能要替換成更準的
        let y = 26 + imageWidth + 2
        let newFrame = CGRect(x: x, y: y, width: underlineWidth, height: 1)

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.underlineView.frame = newFrame
            }
        } else {
            underlineView.frame = newFrame
        }
    }
}

// MARK: UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    // 點擊到TabBar項目時，更新底線的位置
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateUnderlinePosition(animated: true)
    }
}
