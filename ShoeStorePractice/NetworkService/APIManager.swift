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
    case invalidUrl
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

    enum APIEndpoint {
        static let categories = "https://api.rainforestapi.com/categories"
        static let request = "https://api.rainforestapi.com/request"
    }

    static let shared: APIManager = .init()

    func performRequest<T: Codable>(with urlRequest: URLRequest, completion: @escaping ((Result<T, Error>) -> Void)) {
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.responseDataNil))
                return
            }
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    /// 取得鞋子分類
    func fetchCategories(_ completion: @escaping ((Result<CategoryResponse, Error>) -> Void)) {
        var urlComponents = URLComponents(string: APIEndpoint.categories)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.apiKey),
            URLQueryItem(name: "domain", value: "amazon.com"),
            URLQueryItem(name: "parent_id", value: "7141124011"),
            URLQueryItem(name: "type", value: "standard")
        ]
        guard let url = urlComponents?.url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        let urlRequest = URLRequest(url: url)
        performRequest(with: urlRequest, completion: completion)
    }

    /// 取得最受歡迎的鞋款
    func fetchBestSellers(_ completion: @escaping ((Result<ShoesResponse, Error>) -> Void)) {
        var urlComponents = URLComponents(string: APIEndpoint.request)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.apiKey),
            URLQueryItem(name: "type", value: "search"),
            URLQueryItem(name: "amazon_domain", value: "amazon.com"),
            URLQueryItem(name: "search_term", value: "shoes"),
            URLQueryItem(name: "category_id", value: "bestsellers_fashion"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "max_page", value: "1")
        ]
        guard let url = urlComponents?.url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        let urlRequest = URLRequest(url: url)
        performRequest(with: urlRequest, completion: completion)
    }

    /// 取得最新上架的鞋款
    func fetchNewestArrivals(_ completion: @escaping ((Result<ShoesResponse, Error>) -> Void)) {
        var urlComponents = URLComponents(string: APIEndpoint.request)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.apiKey),
            URLQueryItem(name: "type", value: "search"),
            URLQueryItem(name: "amazon_domain", value: "amazon.com"),
            URLQueryItem(name: "search_term", value: "shoes"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "sort_by", value: "most_recent")
        ]
        guard let url = urlComponents?.url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        let urlRequest = URLRequest(url: url)
        performRequest(with: urlRequest, completion: completion)
    }
}
