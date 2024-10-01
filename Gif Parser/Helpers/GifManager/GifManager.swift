//
//  GifManager.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import UIKit

/// Protocol for gif manager
protocol GifManagerProtocol {

	/// Get the list of trending gifs
	func getTrending(limit: Int, offset: Int) async -> [GifRepresentableModel]
}

/// Manager for gifs
final class GifManager: GifManagerProtocol {

	// MARK: - Private Properties

	private let apiService: ApiServiceProtocol
	private let gifService: GifServiceProtocol
	private let gifCacheService: GifCacheServiceProtocol

	// MARK: - Init

	init(
		apiService: ApiServiceProtocol,
		gifService: GifServiceProtocol,
		gifCacheService: GifCacheServiceProtocol
	) {
		self.apiService = apiService
		self.gifService = gifService
		self.gifCacheService = gifCacheService
	}

	// MARK: - Public Methods

	func getTrending(limit: Int, offset: Int) async -> [GifRepresentableModel] {
		let endpoint = ApiEndpointFactory.makeTrendingGifEndpoint(limit: limit, offset: offset)
		do {
			guard let gifs: GifModel = try await apiService.sendRequest(to: endpoint) else {
				return []
			}

			return await convertToRepresentableModel(gifs: gifs)
		} catch {
			return []
		}
	}

	// MARK: - Private Methods

	private func convertToRepresentableModel(gifs: GifModel) async -> [GifRepresentableModel] {
		var result = [GifRepresentableModel]()

		for gif in gifs.data {
			guard let url = gif.images.original.url else { continue }

			var image: UIImage? = nil
			if let gif = gifCacheService.getGif(for: url) {
				image = UIImage.getGif(from: gif)
			} else {
				if let imageData = await gifService.downloadGif(from: url) {
					image = UIImage.getGif(from: imageData)

					if image != nil {
						gifCacheService.saveGif(imageData, for: url)
					}
				}
			}

			guard let image else { continue }
			result.append(GifRepresentableModel(image: image))
		}

		return result
	}
}
