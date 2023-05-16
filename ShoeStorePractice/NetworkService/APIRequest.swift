//
//  APIRequest.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import Foundation

// MARK: - APIRequest

protocol APIRequest {
    // 讓每個API請求定義自己的特定回應類型
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: ContentType { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
}

extension APIRequest {
    var baseURL: URL {
        return URL(string: "https://api.rainforestapi.com")!
    }

    var contentType: ContentType {
        return .json
    }
}

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case query = "QUERY"
    case trace = "TRACE"
}

// MARK: - ContentType

enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded; charset=utf-8"
    case multiPartFormData = "multipart/form-data"
}
