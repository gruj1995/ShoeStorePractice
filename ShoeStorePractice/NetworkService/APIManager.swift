//
//  APIManager.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import Foundation
import SwiftyJSON

// MARK: - NetworkError

enum NetworkError: Error {
    case inputDataNilOrZeroLength
    case inputFileNil
    case responseDataNil
    case jsonSerializationFailed(error: Error)
    case decodingFailed(error: Error)
    case customSerializationFailed(error: Error)
    case invalidEmptyResponse(type: String)
}

// MARK: - APIManager

class APIManager {
    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static let shared: APIManager = .init()

    /// 取得鞋子分類
    func fetchCategories(_ completion: @escaping ((Result<CategoryResponse, Error>) -> Void)) {
        guard let url = URL(string: "https://api.rainforestapi.com/categories?api_key=\(Constants.apiKey)&domain=amazon.com&parent_id=7141124011&type=standard") else {
            completion(.failure(NetworkError.inputDataNilOrZeroLength))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(NetworkError.responseDataNil))
                return
            }
            do {
                let response = try JSONDecoder().decode(CategoryResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    /// 取得最受歡迎的鞋款
    func fetchBestSellers(_ completion: @escaping ((Result<ShoesResponse, Error>) -> Void)) {
        guard let url = URL(string: "https://api.rainforestapi.com/request?api_key=\(Constants.apiKey)&type=search&amazon_domain=amazon.com&search_term=shoes&category_id=bestsellers_fashion&page=1&max_page=1") else {

            completion(.failure(NetworkError.inputDataNilOrZeroLength))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(NetworkError.responseDataNil))
                return
            }
            do {
                let response = try JSONDecoder().decode(ShoesResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    /// 取得最新上架的鞋款
    func fetchNewestArrivals(_ completion: @escaping ((Result<ShoesResponse, Error>) -> Void)) {
        guard let url = URL(string: "https://api.rainforestapi.com/request?api_key=\(Constants.apiKey)&type=search&amazon_domain=amazon.com&search_term=shoes&page=1&sort_by=most_recent") else {
            completion(.failure(NetworkError.inputDataNilOrZeroLength))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(NetworkError.responseDataNil))
                return
            }

            do {
                let response = try JSONDecoder().decode(ShoesResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
