//
//  LatestShoeInfo.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/16.
//

import Foundation

struct LatestShoeInfo {
    let data: SearchResult?

    var imageUrl: URL? {
        guard let urlString = data?.image else {
            return nil
        }
        return URL(string: urlString)
    }

    var isLike: Bool
//    var onLikeButtonTapped: (() -> Void)?
}
