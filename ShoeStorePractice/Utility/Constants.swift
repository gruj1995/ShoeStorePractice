//
//  Constants.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import UIKit

enum Constants {

    // Rainforest Api key
    static let apiKey = "9D02D6CF9F2A43FC89D79DB23C9F515F"

    /// 一般請求Timeout
    static let timeoutIntervalForRequest = TimeInterval(30)

    /// long polling Timeout(Server設30秒 所以client設60秒 要聽到server的正常timeout訊息)
    static let timeoutIntervalForLongPolling = TimeInterval(60)

    static let screenSize: CGRect = UIScreen.main.bounds

    static let screenWidth = Constants.screenSize.width

    static let screenHeight = Constants.screenSize.height

    static let tabBarHeight: CGFloat = screenHeight / 9

    static let isDebug: Bool = false
}
