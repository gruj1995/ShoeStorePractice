//
//  ShoeInfo.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import Foundation

struct ShoeInfo {
    let data: SearchResult?

    var brand: String {
        data?.brand ?? ""
    }

    var description: String {
        guard let title = data?.title else {
            return ""
        }
        return title.trimmingCharacters(in: CharacterSet(charactersIn: brand))
    }

    var amountString: String {
        data?.price?.raw ?? ""
    }

    var imageUrl: URL? {
        guard let urlString = data?.image else {
            return nil
        }
        return URL(string: urlString)
    }
}
