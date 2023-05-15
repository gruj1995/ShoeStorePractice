//
//  AppDelegate.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import UIKit
#if DEBUG
import FLEX
#endif

// MARK: - AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
#if DEBUG
        FLEXManager.shared.isNetworkDebuggingEnabled = true
#endif
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        initializeGlobals()
        setupAppearance()
        setNavigationBarAppearance()

#if DEBUG
        FLEXManager.shared.isNetworkDebuggingEnabled = true
#endif
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    /// 設置螢幕支持的方向
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

extension AppDelegate {
    /// 設置全域變數
    private func initializeGlobals() {
        // 修正ios 15 tableView section 上方多出的空白
        UITableView.appearance().sectionHeaderTopPadding = 0.0
    }

    /// 設置界面樣式，例如導航欄外觀、顏色等
    private func setupAppearance() {
        // 要先到 info.plist 新增 key(View controller-based status bar appearance) 以下設置才有效
        UIApplication.shared.statusBarStyle = .lightContent

        // 設置所有 UIBarButtonItem 的 tinitColor
        UIBarButtonItem.appearance().tintColor = .appColor(.black)
    }

    private func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground() // 透明背景且無陰影(隱藏底部邊框)
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.black),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]

        // 返回按鈕樣式
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance = backButtonAppearance
        let backImg = AppImages.chevronLeft
        appearance.setBackIndicatorImage(backImg, transitionMaskImage: backImg)

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension UIWindow {
#if DEBUG
    /// 搖動出現debug套件
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            FLEXManager.shared.showExplorer()
        }
    }
#endif
}

