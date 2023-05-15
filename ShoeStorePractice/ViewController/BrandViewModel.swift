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
typealias ShoeCategoryCellConfig = CollectionCellConfigurator<ShoeCategoryCell, String>

// MARK: - HomePageViewModel

class BrandViewModel {

    enum SectionData: CaseIterable {
        case brand
        case shoeCategories
        case shoeCategory
        case latest
    }

    var sectionDatas: [SectionData] = SectionData.allCases

    private(set) var items: [CellConfigurator] = []

    private(set) var datas = [[CellConfigurator]]()
    private(set) var brand: [CellConfigurator] = []
    private(set) var shoeCategories: [CellConfigurator] = []
    private(set) var shoeCategoryItems: [CellConfigurator] = []
    private(set) var latestItems: [CellConfigurator] = []

    // MARK: Lifecycle

    init(vc: BrandViewController) {
//        items = [
//            CategoryContainerCellConfig.init(item: vc),
//            BrandContainerCellConfig.init(item: vc)
//        ]
        brand = [BrandInfoCellConfig.init(item: "w")]

        shoeCategories = [
            ShoeCategoryCellConfig.init(item: "Running"),
            ShoeCategoryCellConfig.init(item: "Casuals"),
            ShoeCategoryCellConfig.init(item: "Test"),
            ShoeCategoryCellConfig.init(item: "d"),
        ]

        shoeCategoryItems = [
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


        datas.append(brand)
        datas.append(shoeCategories)
        datas.append(shoeCategoryItems)
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
