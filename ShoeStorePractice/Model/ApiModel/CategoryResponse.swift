//
//  CategoryResponse.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import Foundation

// MARK: - CategoryResponse

struct CategoryResponse: Codable {
    // MARK: Internal

    var categories: [CategoryResult]?

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case categories
    }
}

// MARK: - CategoryData

struct CategoryResult: Codable {
    // MARK: Internal

    let isRoot: Bool?
    let domain: String?
    let id: String?
    let parentName: String?
    let link: String?
    let parentId: String?
    let path: String?
    let hasChildren: Bool?
    let name: String?
    let type: String?

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case isRoot = "is_root"
        case domain
        case id
        case parentName = "parent_name"
        case link
        case parentId = "parent_id"
        case path
        case hasChildren = "has_children"
        case name
        case type
    }
}
