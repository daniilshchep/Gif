//
//  MainViewController.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import UIKit

/// Protocol for main controller
protocol MainViewControllerProtocol: UIViewController {

	/// Setup gifs in view controller
	func setupGifs(_ gifs: [GifRepresentableModel])
}

/// Main view controller
final class MainViewController: UIViewController, MainViewControllerProtocol {

	// MARK: - UI Components

	private let loadingActivityIndicatorView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: .large)
		view.hidesWhenStopped = true
		return view
	}()

	private lazy var gifCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		layout.sectionInset = .zero

		let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.dataSource = self
		view.delegate = self
		view.backgroundColor = .clear
		view.register(GifCell.self, forCellWithReuseIdentifier: GifCell.identifier)
		view.register(
			UICollectionReusableView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: "LoadingFooterView"
		)

		return view
	}()

	private var gifCollectionViewFooterActivityIndicator: UIActivityIndicatorView?

	// MARK: - Public Properties

	var presenter: MainViewControllerPresenterProtocol?

	// MARK: - Private Properties

	private var gifs = [GifRepresentableModel]()
	private var page: Int = 1
	private var isLoading: Bool = false

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupViews()
		loadData()
		loadingActivityIndicatorView.startAnimating()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}

	// MARK: - Public Methods

	func setupGifs(_ gifs: [GifRepresentableModel]) {
		page += 1

		self.gifs.append(contentsOf: gifs)
		self.isLoading = false

		gifCollectionView.reloadData()
		loadingActivityIndicatorView.stopAnimating()
		gifCollectionViewFooterActivityIndicator?.stopAnimating()
	}

	// MARK: - Private Methods

	private func setupViews() {
		view.backgroundColor = .systemBackground

		[loadingActivityIndicatorView, gifCollectionView].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}

		NSLayoutConstraint.activate([
			loadingActivityIndicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			loadingActivityIndicatorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
			loadingActivityIndicatorView.widthAnchor.constraint(equalToConstant: 32),
			loadingActivityIndicatorView.heightAnchor.constraint(equalToConstant: 32),

			gifCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			gifCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			gifCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			gifCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
	}

	private func loadData() {
		guard !isLoading else { return }

		isLoading = true

		presenter?.getTrending(for: page)
	}
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		return gifs.count
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.identifier, for: indexPath) as? GifCell else {
			return UICollectionViewCell()
		}
		cell.setupContent(image: gifs[indexPath.row].image)
		return cell
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		return CGSize(width: collectionView.bounds.width / 2, height: 128)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		didSelectItemAt indexPath: IndexPath
	) {
		if let image = gifs[indexPath.row].image {
			presenter?.shareGif(image)
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionFooter {
			let footerView = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: "LoadingFooterView",
				for: indexPath
			)

			footerView.subviews.forEach { $0.removeFromSuperview() }

			let activityIndicator = UIActivityIndicatorView(style: .large)
			activityIndicator.translatesAutoresizingMaskIntoConstraints = false
			activityIndicator.hidesWhenStopped = true
			footerView.addSubview(activityIndicator)

			NSLayoutConstraint.activate([
				activityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
				activityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
				activityIndicator.widthAnchor.constraint(equalToConstant: 32),
				activityIndicator.heightAnchor.constraint(equalToConstant: 32)
			])

			gifCollectionViewFooterActivityIndicator = activityIndicator

			return footerView
		}

		return UICollectionReusableView()
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForFooterInSection section: Int
	) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 50)
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height

		if offsetY > contentHeight - scrollView.frame.size.height && !gifs.isEmpty {
			gifCollectionViewFooterActivityIndicator?.startAnimating()
			loadData()
		}
	}
}
