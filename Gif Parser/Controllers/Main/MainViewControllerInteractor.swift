//
//  MainViewControllerInteractor.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

/// Protocol for main controller interactor
protocol MainViewControllerInteractorProtocol {

	/// Get trending gifs
	func getTrending(limit: Int, offset: Int) async -> [GifRepresentableModel]
}

/// Main view controller interactor
final class MainViewControllerInteractor: MainViewControllerInteractorProtocol {

	// MARK: - Public Properties
	
	var presenter: MainViewControllerPresenterProtocol?

	// MARK: - Private Properties

	private let gifManager: GifManagerProtocol

	// MARK: - Init

	init(gifManager: GifManagerProtocol) {
		self.gifManager = gifManager
	}

	// MARK: - Public Methods

	func getTrending(limit: Int, offset: Int) async -> [GifRepresentableModel] {
		return await gifManager.getTrending(limit: limit, offset: offset)
	}
}
