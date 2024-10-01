//
//  MainViewControllerRouter.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import UIKit

/// Protocol for main controller router
protocol MainViewControllerRouterProtocol {

	/// Share gif using system controller
	func shareGif(_ image: UIImage)
}

/// Main view controller router
final class MainViewControllerRouter: MainViewControllerRouterProtocol {

	// MARK: - Public Properties

	var view: MainViewControllerProtocol?

	// MARK: - Public Methods

	func shareGif(_ image: UIImage) {
		guard let gifData = image.converImageToData() else { return }

		let activityViewController = UIActivityViewController(activityItems: [gifData], applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = view?.view
		view?.present(activityViewController, animated: true, completion: nil)
	}
}
