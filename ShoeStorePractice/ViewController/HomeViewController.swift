//
//  HomeViewController.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import Combine
import SnapKit
import UIKit

// MARK: - HomeViewController

class HomeViewController: UIViewController {
    // MARK: Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        setupUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: Private

    private var viewModel: HomeViewModel!
    private var cancellables: Set<AnyCancellable> = .init()

    // MARK: View

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.reuseId)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseId)
        collectionView.register(BrandCell.self, forCellWithReuseIdentifier: BrandCell.reuseId)
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

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.isHidden = true
        return view
    }()

    // MARK: CollectionLayout

    private lazy var layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        let sectionType = self.viewModel.sectionType(sectionIndex)
        switch sectionType {
        case .category:
            return self.categorySection
        case .brand:
            return self.brandSection
        case .popular:
            return self.popularSection
        case .latest:
            return self.latestSection
        default:
            return nil
        }
    }

    private lazy var categorySection: NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(148), heightDimension: .absolute(82))
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 14 // 設置水平間距
        section.contentInsets = contentInsets
        section.orthogonalScrollingBehavior = .continuous // 橫向捲動
        section.boundarySupplementaryItems = [self.createSectionHeader()]
        return section
    }()

    // 垂直排列，橫向最多兩個，縱向最多六個
    private lazy var brandSection: NSCollectionLayoutSection = {
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7.5, bottom: 0, trailing: 7.5)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = contentInsets
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        section.interGroupSpacing = 14 // 設置垂直間距
        let headerContentInsets = contentInsets
        section.boundarySupplementaryItems = [self.createSectionHeader(insets: headerContentInsets)]
        return section
    }()

    private lazy var popularSection: NSCollectionLayoutSection = {
        let fraction: CGFloat = 0.83
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        section.interGroupSpacing = 21 
        section.orthogonalScrollingBehavior = .continuous // 橫向捲動
        section.boundarySupplementaryItems = [self.createSectionHeader()]
        return section
    }()

    private lazy var latestSection: NSCollectionLayoutSection = {
        let fraction: CGFloat = 0.5
        let padding: CGFloat = 15 // group 與外部間隔
        let spacing: CGFloat = 11 // cell 間隔
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: padding + spacing / 2, trailing: padding)
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

    private func createSectionHeader(insets: NSDirectionalEdgeInsets = .zero) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = insets
        return header
    }

    // MARK: Setup

    private func setupUI() {
        view.backgroundColor = .appColor(.white)
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(emptyStateView)
        emptyStateView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
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
        activityIndicator.stopAnimating()

        if viewModel.datas.isEmpty {
            showNoResultView()
        } else {
            collectionView.reloadData()
            showCollectionView()
        }
    }

    private func showCollectionView() {
        emptyStateView.isHidden = true
        collectionView.isHidden = false
    }

    private func showNoResultView() {
        emptyStateView.configure(title: "沒有結果", message: "請檢查連線是否異常。")
        emptyStateView.isHidden = false
        collectionView.isHidden = true
    }

    private func handleError(_ error: Error) {
        activityIndicator.stopAnimating()
        showNoResultView()
    }

    private func pushToBrandVC() {
        let vc = BrandViewController()
        vc.dataSource = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        guard let sectionType = viewModel.sectionType(indexPath.section) else {
            return
        }
        switch sectionType {
        case .category, .popular:
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        case .brand:
            viewModel.setSelectBrand(forCellAt: indexPath.item)
            pushToBrandVC()
        default:
            return
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderView.reuseId, for: indexPath) as? TitleHeaderView else {
            return UICollectionReusableView()
        }
        guard let sectionType = viewModel.sectionType(indexPath.section) else {
            return header
        }
        let showSeeMoreButton = sectionType != .category
        header.configure(title: sectionType.title, showSeeMoreButton: showSeeMoreButton)
        header.onSeeMoreButtonTapped = { _ in
            print("see more button tapped")
        }
        return header
    }
}

extension HomeViewController: BrandViewControllerDataSource {
    func brand(_ vc: BrandViewController) -> Brand? {
        viewModel.selectedBrand
    }
}
