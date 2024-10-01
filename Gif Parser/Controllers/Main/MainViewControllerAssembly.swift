//
//  MainViewControllerAssembly.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

/// Protocol for main controller assembly
protocol MainViewControllerAssemblyProtocol {

	/// Build main view controller
	func makeMainViewController() -> MainViewControllerProtocol
}

/// Main view controller assembly
final class MainViewControllerAssembly: MainViewControllerAssemblyProtocol {

	func makeMainViewController() -> MainViewControllerProtocol {
		let jsonParser = JsonParser()
		let apiService = ApiService(jsonParser: jsonParser)
		let gifService = GifService()
		let gifCacheService = GifCacheService()
		let gifManager = GifManager(
			apiService: apiService,
			gifService: gifService,
			gifCacheService: gifCacheService
		)

		let view = MainViewController()
		let presenter = MainViewControllerPresenter()
		let interactor = MainViewControllerInteractor(gifManager: gifManager)
		let router = MainViewControllerRouter()

		view.presenter = presenter

		presenter.view = view
		presenter.interactor = interactor
		presenter.router = router

		interactor.presenter = presenter

		router.view = view

		return view
	}
}
