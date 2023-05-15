//
//  BrandViewController.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import Combine
import SnapKit
import UIKit

// MARK: - BrandViewController

class BrandViewController: UIViewController {
    // MARK: Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BrandViewModel(vc: self)
        setupUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: Private

    private var viewModel: BrandViewModel!
    private var cancellables: Set<AnyCancellable> = .init()

    // 抓取資料時的旋轉讀條 (可以搜尋"egaf"，觀察在資料筆數小的情況下怎麼顯示)
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    // 下拉 tableView 更新資料
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .lightGray
        let attributedString = NSAttributedString(string: "更新資料", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ])
        refreshControl.attributedTitle = attributedString
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refreshControl.addTarget(self, action: #selector(reloadTracks), for: .valueChanged)
        return refreshControl
    }()

    // MARK: View

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.reuseId)
        collectionView.register(BrandInfoCell.self, forCellWithReuseIdentifier: BrandInfoCell.reuseId)
        collectionView.register(ShoeCategoryCell.self, forCellWithReuseIdentifier: ShoeCategoryCell.reuseId)
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: PopularCell.reuseId)
        collectionView.register(LatestCell.self, forCellWithReuseIdentifier: LatestCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .appColor(.white)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        // 避免底部被tabBar遮到
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        return collectionView
    }()

    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.isHidden = true
        return view
    }()

    // MARK: CollectionLayout

    private lazy var layout: UICollectionViewCompositionalLayout =  UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
        switch sectionIndex {
        case 0:
            return self.categorySection
        case 1:
            return self.shoeCategoriesSection
        case 2:
            return self.shoeCategorySection
        case 3:
            return self.latestSection
        default:
            return nil
        }
    }

    private func createSectionHeader(insets: NSDirectionalEdgeInsets = .zero) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = insets
        return header
    }

    private lazy var categorySection: NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.47))
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        section.orthogonalScrollingBehavior = .none // 橫向捲動
//        section.boundarySupplementaryItems = [self.createSectionHeader()]
        return section
    }()

    private lazy var shoeCategoriesSection: NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(45))
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15  // 設置水平間距
        section.contentInsets = contentInsets
        section.orthogonalScrollingBehavior = .continuous // 橫向捲動
//        section.boundarySupplementaryItems = [self.createSectionHeader(headerHeight: 35)]
        return section
    }()

    private lazy var shoeCategorySection: NSCollectionLayoutSection = {
        let fraction: CGFloat = 0.85
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        section.orthogonalScrollingBehavior = .paging // 橫向捲動
        section.boundarySupplementaryItems = [self.createSectionHeader()]
        return section
    }()

    private lazy var latestSection: NSCollectionLayoutSection = {
        let fraction: CGFloat = 0.5
        let padding: CGFloat = 15 // group 與外部間隔
        let spacing: CGFloat = 11 // cell 間隔
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: (padding + spacing / 2), trailing: padding)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        // 每個group包含2個item
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2) //
        group.interItemSpacing = .fixed(spacing)
        group.contentInsets = contentInsets
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging // 橫向捲動
        let headerContentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
        section.boundarySupplementaryItems = [self.createSectionHeader(insets: headerContentInsets)]
        return section
    }()

    // MARK: Setup

    private func setupUI() {
        view.backgroundColor = .appColor(.white)
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }

        view.addSubview(emptyStateView)
        emptyStateView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }

    private func bindViewModel() {
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .success:
                    self.updateUI()
                case .failed(let error):
                    self.handleError(error)
                case .loading, .none:
                    return
                }
            }.store(in: &cancellables)
    }

    @objc
    private func updateUI() {
        refreshControl.endRefreshing()

        if viewModel.totalCount == 0, !viewModel.searchTerm.isEmpty {
            showNoResultView()
        } else {
            collectionView.reloadData()
            showTableView()
        }
    }

    private func showTableView() {
        emptyStateView.isHidden = true
        collectionView.isHidden = false
    }

    private func showNoResultView() {
        emptyStateView.configure(title: "沒有結果", message: "嘗試新的搜尋項目。")
        emptyStateView.isHidden = false
        collectionView.isHidden = true
    }

    private func handleError(_ error: Error) {
        refreshControl.endRefreshing()
        showNoResultView()
    }

    @objc
    private func reloadTracks() {
        viewModel.state = .success
        //        viewModel.reloadTracks()
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension BrandViewController: CollectionViewData {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.datas.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionData = viewModel.datas[section]
        if section == 1 {
            return min(6, sectionData.count)
        }
        return sectionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = viewModel.datas[indexPath.section]
        let item = section[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderView.reuseId, for: indexPath) as! TitleHeaderView

        let sectionData = viewModel.sectionDatas[indexPath.section]
        header.configure(title: "ss", showSeeMoreButton: indexPath.section != 0)
        header.onSeeMoreButtonTapped = { [weak self] _ in
            print("__+++")
        }
        return header
    }
}
