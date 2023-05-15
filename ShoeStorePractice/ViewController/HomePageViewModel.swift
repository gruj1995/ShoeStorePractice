//
//  HomePageViewModel.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import Combine
import Foundation

// MARK: CollectionCellConfigurator

typealias CategoryCellConfig = CollectionCellConfigurator<CategoryCell, String>
typealias BrandCellConfig = CollectionCellConfigurator<BrandCell, Brand>
typealias PopularCellConfig = CollectionCellConfigurator<PopularCell, String>
typealias LatestCellConfig = CollectionCellConfigurator<LatestCell, String>

// MARK: - HomePageViewModel

class HomePageViewModel {

    enum SectionData: CaseIterable {
        case category
        case brand
        case popular
        case latest

        var title: String {
            switch self {
            case .category: return "Choose a Category"
            case .brand: return "Select a Brand"
            case .popular: return "What’s Popular"
            case .latest: return "Latest shoes"
            }
        }
    }

    var sectionDatas: [SectionData] = SectionData.allCases

    private(set) var items: [CellConfigurator] = []

    private(set) var datas = [[CellConfigurator]]()
    private(set) var categories: [CellConfigurator] = []
    private(set) var brands: [CellConfigurator] = []
    private(set) var popularItems: [CellConfigurator] = []
    private(set) var latestItems: [CellConfigurator] = []

    // MARK: Lifecycle

    init(vc: HomeViewController) {
//        items = [
//            CategoryContainerCellConfig.init(item: vc),
//            BrandContainerCellConfig.init(item: vc)
//        ]

        categories = [
            CategoryCellConfig.init(item: "a"),
            CategoryCellConfig.init(item: "b"),
            CategoryCellConfig.init(item: "c"),
            CategoryCellConfig.init(item: "d"),
        ]

        brands = Brand.allCases.map { BrandCellConfig.init(item: $0) }

        popularItems = [
            PopularCellConfig.init(item: "Adidas"),
            PopularCellConfig.init(item: "Nike"),
        ]

        // 強制為偶數
        latestItems = [
            LatestCellConfig.init(item: "Adidas"),
            LatestCellConfig.init(item: "Nike"),
            LatestCellConfig.init(item: "Puma"),
            LatestCellConfig.init(item: "Hon")
        ]


        datas.append(categories)
        datas.append(brands)
        datas.append(popularItems)
        datas.append(latestItems)
        state = .success

        //        $searchTerm
        //            .debounce(for: 0.5, scheduler: RunLoop.main) // 延遲觸發搜索操作(0.5s)
        //            .removeDuplicates() // 避免在使用者輸入相同的搜索文字時重複執行搜索操作
        //            .sink { [weak self] term in
        //                self?.searchTrack(with: term)
        //            }.store(in: &cancellables)
    }

    // MARK: Internal

//    private(set) var selectedTrack: Track?

    @Published var searchTerm: String = ""
    @Published var state: ViewState = .none

//    var currentTrackIndexPublisher: AnyPublisher<Int, Never> {
//        musicPlayer.currentTrackIndexPublisher
//    }
//
//    var isPlayingPublisher: AnyPublisher<Bool, Never> {
//        musicPlayer.isPlayingPublisher
//    }


    var totalCount: Int {
        tracks.count
    }

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = .init()

    private var tracks: [String] = []
    private var currentPage: Int = 0
    private var totalPages: Int = 0
    private var pageSize: Int = 20
    private var hasMoreData: Bool = true

}

enum Brand: String, CaseIterable {
    case adidas
    case puma
    case nike
    case crocs
    case skechers
    case reebok
    case adidas1
}
