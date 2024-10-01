//
//  GifService.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import UIKit

/// Protocol for gif service
protocol GifServiceProtocol {

	/// Download gif from specific url
	func downloadGif(from url: String) async -> Data?
}

/// Service for gif related stuff
final class GifService: GifServiceProtocol {

	func downloadGif(from url: String) async -> Data? {
		guard let imageUrl = URL(string: url) else {
			return nil
		}

		do {
			let (data, _) = try await URLSession.shared.data(from: imageUrl)

			return data
		} catch {
			return nil
		}
	}
}
