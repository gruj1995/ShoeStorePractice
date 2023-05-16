//
//  BrandViewModel.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import Combine
import Foundation

// MARK: CollectionCellConfigurator

typealias BrandInfoCellConfig = CollectionCellConfigurator<BrandInfoCell, String>
typealias ShoeCategoryCellConfig = CollectionCellConfigurator<ShoeCategoryCell, ShoeCategory>

// MARK: - BrandViewModel

class BrandViewModel {
    // MARK: Lifecycle

    init() {
        fetchData()
    }

    // MARK: Internal

    enum SectionType: Int, CaseIterable {
        case brand
        case shoeCategories
        case shoeCategory
        case latest
    }

    private(set) var datas = [[CellConfigurator]]()
    private(set) var brand: [CellConfigurator] = []
    private(set) var shoeCategoryItems: [CellConfigurator] = []
    private(set) var latestItems: [CellConfigurator] = []

    @Published var state: ViewState = .none

    var selectedShoeCategory: ShoeCategory? {
        guard let config = shoeCategories[selectedCategoryIndex] as? ShoeCategoryCellConfig else {
            return nil
        }
        return config.item
    }

    func setSelectedShoeCategory(forCellAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        updateShoeCategories()
    }

    func fetchData() {
        state = .loading
        datas.removeAll()
        let group = DispatchGroup()

        group.enter()
        fetchMockShoeCategories { _ in
            group.leave()
        }

//        group.enter()
//        fetchMockShoeCategories() { result in
//            group.leave()
//        }
//
//        group.enter()
//        fetchNewestArrivals() { result in
//            group.leave()
//        }

        group.enter()
        fetchMockShoeCategoryItems { _ in
            group.leave()
        }

        group.enter()
        fetchMockNewestArrivals { _ in
            group.leave()
        }

        group.notify(queue: .main) {
            self.brand = [BrandInfoCellConfig(item: "w")]
            self.setData()
            self.state = .success
        }
    }

    func item(forCellAt indexPath: IndexPath) -> CellConfigurator? {
        let section = datas[indexPath.section]
        let item = section[indexPath.row]
        return item
    }

    func sectionTitle(_ section: Int) -> String {
        let sectionType = SectionType(rawValue: section)
        if sectionType == .shoeCategory {
            return selectedShoeCategory?.title ?? ""
        } else if sectionType == .latest {
            return "Latest shoes"
        }
        return ""
    }

    // MARK: Private

    private var sectionTypes: [SectionType] = SectionType.allCases
    private var shoeCategories: [CellConfigurator] = []
    private var selectedCategoryIndex: Int = 0

    private func setData() {
        datas.append(brand)
        datas.append(shoeCategories)
        datas.append(shoeCategoryItems)
        datas.append(latestItems)
    }

    private func updateShoeCategories() {
        guard let configs = shoeCategories as? [ShoeCategoryCellConfig] else { return }
        var newConfigs: [ShoeCategoryCellConfig] = []

        for (index, config) in configs.enumerated() {
            let isSelected = (index == selectedCategoryIndex)
            let newConfig = ShoeCategoryCellConfig(item: ShoeCategory(title: config.item.title, isSelected: isSelected))
            newConfigs.append(newConfig)
        }

        datas[1] = newConfigs
    }

    private func fetchMockShoeCategories(_ completion: @escaping ((Error?) -> Void)) {
        shoeCategories = [
            ShoeCategoryCellConfig(item: ShoeCategory(title: "Running", isSelected: true)),
            ShoeCategoryCellConfig(item: ShoeCategory(title: "Casuals")),
            ShoeCategoryCellConfig(item: ShoeCategory(title: "Walking")),
            ShoeCategoryCellConfig(item: ShoeCategory(title: "Athletic"))
        ]
        completion(nil)
    }

    private func fetchShoeCategoryItems(_ completion: @escaping ((Error?) -> Void)) {
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
                self.shoeCategoryItems = prefixResults.compactMap {
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

extension BrandViewModel {
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

    private func fetchMockShoeCategoryItems(_ completion: @escaping ((Error?) -> Void)) {
        let response: ShoesResponse? = mockResponse(.popular)
        guard let searchResults = response?.searchResults else { return }
        shoeCategoryItems = searchResults.compactMap {
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

// MARK: - ShoeCategory

struct ShoeCategory: Equatable {
    var title: String
    var isSelected: Bool = false
}
