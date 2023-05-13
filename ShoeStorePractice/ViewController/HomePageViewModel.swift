//
//  HomePageViewModel.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import Combine
import Foundation

// MARK: - HomePageViewModel

class HomePageViewModel {
    // MARK: Lifecycle

    init() {
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
