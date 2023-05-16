//
//  ShoesResponse.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import Foundation

// MARK: - PopularShoesResponse

struct ShoesResponse: Codable {
    // MARK: Internal

    let searchResults: [SearchResult]?

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case searchResults = "search_results"
    }
}

// MARK: - SearchResult

struct SearchResult: Codable {
    // MARK: Internal

    let position: Int?
    let title: String?
    let link: String?
    let brand: String?
    let image: String?
    let isPrime: Bool?
    let rating: Double?
    let ratingsTotal: Int?
    let price: Price?

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case position, title,  link, brand, image, rating, price
        case isPrime = "is_prime"
        case ratingsTotal = "ratings_total"
    }
}

// MARK: - Price

struct Price: Codable {
    // MARK: Internal

    let symbol: String?
    let value: Double?
    let currency: String?
    let raw: String?
    let name: String?
    let isPrimary: Bool?

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case symbol, value, currency, raw, name, isPrimary = "is_primary"
    }
}
