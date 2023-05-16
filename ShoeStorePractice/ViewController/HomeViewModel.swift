//
//  HomeViewModel.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import Combine
import Foundation

// MARK: CollectionCellConfigurator

typealias CategoryCellConfig = CollectionCellConfigurator<CategoryCell, Category>
typealias BrandCellConfig = CollectionCellConfigurator<BrandCell, Brand>
typealias PopularCellConfig = CollectionCellConfigurator<PopularCell, ShoeInfo>
typealias LatestCellConfig = CollectionCellConfigurator<LatestCell, LatestShoeInfo>

// MARK: - HomeViewModel

class HomeViewModel {
    // MARK: Lifecycle

    init() {
        brands = Brand.allCases.map { BrandCellConfig(item: $0) }
        fetchData()
    }

    // MARK: Internal

    enum SectionData: CaseIterable {
        case category
        case brand
        case popular
        case latest

        // MARK: Internal

        var title: String {
            switch self {
            case .category: return "Choose a Category"
            case .brand: return "Select a Brand"
            case .popular: return "What’s Popular"
            case .latest: return "Latest shoes"
            }
        }
    }

    private(set) var sectionDatas: [SectionData] = SectionData.allCases
    private(set) var datas = [[CellConfigurator]]()
    private(set) var categories: [CellConfigurator] = []
    private(set) var brands: [CellConfigurator] = []
    private(set) var popularItems: [CellConfigurator] = []
    private(set) var latestItems: [CellConfigurator] = []

    @Published var state: ViewState = .none

    // MARK: Private

    func fetchData() {
        state = .loading
        datas.removeAll()
        let group = DispatchGroup()

        group.enter()
        fetchCategories { _ in
            group.leave()
        }

        group.enter()
        fetchBestSellers() { result in
            group.leave()
        }

        group.enter()
        fetchNewestArrivals() { result in
            group.leave()
        }

//        group.enter()
//        fetchMockBestSellers { _ in
//            group.leave()
//        }
//
//        group.enter()
//        fetchMockNewestArrivals { _ in
//            group.leave()
//        }

        group.notify(queue: .main) {
            self.setData()
            self.state = .success
        }
    }

    private func setData() {
        datas.append(categories)
        datas.append(brands)
        datas.append(popularItems)
        datas.append(latestItems)
    }

    private func fetchCategories(_ completion: @escaping ((Error?) -> Void)) {
        APIManager.shared.fetchCategories { [weak self] result in
            guard let self else {
                completion(NetworkError.inputDataNilOrZeroLength)
                return
            }
            switch result {
            case .success(let response):
                guard let categories = response.categories else {
                    completion(NetworkError.invalidEmptyResponse(type: "categories are empty"))
                    return
                }
                self.categories = categories.compactMap {
                    let category = Category(data: $0)
                    return CategoryCellConfig(item: category)
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    private func fetchBestSellers(_ completion: @escaping ((Error?) -> Void)) {
        APIManager.shared.fetchBestSellers { [weak self] result in
            guard let self else {
                completion(NetworkError.inputDataNilOrZeroLength)
                return
            }
            switch result {
            case .success(let response):
                guard let searchResults = response.searchResults else {
                    completion(NetworkError.invalidEmptyResponse(type: "searchResults are empty"))
                    return
                }
                let prefixResults = searchResults.prefix(5)
                self.popularItems = prefixResults.compactMap {
                    let shoeInfo = ShoeInfo(data: $0)
                    return PopularCellConfig(item: shoeInfo)
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    private func fetchNewestArrivals(_ completion: @escaping ((Error?) -> Void)) {
        APIManager.shared.fetchNewestArrivals { [weak self] result in
            guard let self else {
                completion(NetworkError.inputDataNilOrZeroLength)
                return
            }
            switch result {
            case .success(let response):
                guard let searchResults = response.searchResults else {
                    completion(NetworkError.invalidEmptyResponse(type: "searchResults are empty"))
                    return
                }
                let prefixResults = searchResults.prefix(6)
                self.latestItems = prefixResults.compactMap {
                    let shoeInfo = LatestShoeInfo(data: $0, isLike: false)
                    return LatestCellConfig(item: shoeInfo)
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}

// MARK: 假資料

extension HomeViewModel {
    enum MockResponseType {
        case popular
        case newst

        // MARK: Internal

        var resource: String {
            switch self {
            case .popular: return "MockPopularShoes"
            case .newst: return "MockNewstShoes"
            }
        }
    }

    private func mockResponse<T: Codable>(_ mockType: MockResponseType) -> T? {
        let resource = mockType.resource
        // 找到 JSON 檔案的路徑
        guard let path = Bundle.main.url(forResource: resource, withExtension: "json") else {
            print("Can't find JSON file.")
            return nil
        }

        do {
            let data = try Data(contentsOf: path)
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            print("Error: \(error)")
            return nil
        }
    }

    private func fetchMockBestSellers(_ completion: @escaping ((Error?) -> Void)) {
        let response: ShoesResponse? = mockResponse(.popular)
        guard let searchResults = response?.searchResults else { return }
        popularItems = searchResults.compactMap {
            let shoeInfo = ShoeInfo(data: $0)
            return PopularCellConfig(item: shoeInfo)
        }
        completion(nil)
    }

    private func fetchMockNewestArrivals(_ completion: @escaping ((Error?) -> Void)) {
        let response: ShoesResponse? = mockResponse(.newst)
        guard let searchResults = response?.searchResults else { return }
        latestItems = searchResults.compactMap {
            let shoeInfo = LatestShoeInfo(data: $0, isLike: false)
            return LatestCellConfig(item: shoeInfo)
        }
        completion(nil)
    }
}