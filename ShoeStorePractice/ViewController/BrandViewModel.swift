//
//  BrandViewModel.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import Combine
import Foundation

// MARK: CollectionCellConfigurator

typealias BrandInfoCellConfig = CollectionCellConfigurator<BrandInfoCell, Brand?>
typealias ShoeCategoryCellConfig = CollectionCellConfigurator<ShoeCategoryCell, ShoeCategory>

// MARK: - BrandViewModel

class BrandViewModel {
    // MARK: Lifecycle

    init(brand: Brand?) {
        self.brand = brand
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
    private(set) var brandConfig: [CellConfigurator] = []
    private(set) var shoeCategoryConfigs: [CellConfigurator] = []
    private(set) var latestConfigs: [CellConfigurator] = []
    private(set) var brand: Brand?

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

        brandConfig = [BrandInfoCellConfig(item: brand)]

        group.enter()
        fetchMockShoeCategories() { result in
            group.leave()
        }

        if Constants.isDebug {
            group.enter()
            fetchMockShoeCategoryItems { _ in
                group.leave()
            }

            group.enter()
            fetchMockNewestArrivals { _ in
                group.leave()
            }
        } else {
            group.enter()
            fetchShoeCategoryItems() { result in
                group.leave()
            }

            group.enter()
            fetchNewestArrivals() { result in
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.setData()
            self.state = .success
        }
    }

    func item(forCellAt indexPath: IndexPath) -> CellConfigurator? {
        let section = datas[indexPath.section]
        let item = section[indexPath.row]
        return item
    }

    func sectionType(_ section: Int) -> SectionType? {
        guard sectionTypes.indices.contains(section) else {
            return nil
        }
        return sectionTypes[section]
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
        datas.append(brandConfig)
        datas.append(shoeCategories)
        datas.append(shoeCategoryConfigs)
        datas.append(latestConfigs)
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
        APIManager.shared.fetchBestSellers(brand: brand) { [weak self] result in
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
                self.shoeCategoryConfigs = prefixResults.compactMap {
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
        APIManager.shared.fetchNewestArrivals(brand: brand)  { [weak self] result in
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
                self.latestConfigs = prefixResults.compactMap {
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
        shoeCategoryConfigs = searchResults.compactMap {
            let shoeInfo = ShoeInfo(data: $0)
            return PopularCellConfig(item: shoeInfo)
        }
        completion(nil)
    }

    private func fetchMockNewestArrivals(_ completion: @escaping ((Error?) -> Void)) {
        let response: ShoesResponse? = mockResponse(.newst)
        guard let searchResults = response?.searchResults else { return }
        latestConfigs = searchResults.compactMap {
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
