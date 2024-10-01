//
//  MainViewControllerPresenter.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import UIKit

/// Protocol for main controller presenter
protocol MainViewControllerPresenterProtocol {

	/// Get trending gifs
	func getTrending(for page: Int)

	/// Share gif
	func shareGif(_ image: UIImage)
}

/// Main view controller presenter
final class MainViewControllerPresenter: MainViewControllerPresenterProtocol {

	// MARK: - Constants

	private struct Constants {
		static let gifsPerPage: Int = 16
	}

	// MARK: - Public Properties

	var view: MainViewControllerProtocol?
	var interactor: MainViewControllerInteractorProtocol?
	var router: MainViewControllerRouterProtocol?

	// MARK: - Public Methods

	func getTrending(for page: Int) {
		Task {
			let gifs = await interactor?.getTrending(
				limit: Constants.gifsPerPage,
				offset: Constants.gifsPerPage * (page - 1)
			) ?? []

			DispatchQueue.main.async {
				self.view?.setupGifs(gifs)
			}
		}
	}

	func shareGif(_ image: UIImage) {
		router?.shareGif(image)
	}
}
