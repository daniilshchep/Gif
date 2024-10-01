//
//  ApiEndpointFactory.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import Foundation

/// Protocol for endpoint factory
protocol ApiEndpointFactoryProtocol {

	/// Endpoint for trending gifs request
	static func makeTrendingGifEndpoint(limit: Int, offset: Int) -> ApiEndpoint
}

/// Endpoint factory
final class ApiEndpointFactory: ApiEndpointFactoryProtocol {

	// MARK: - Constants

	private struct Constants {
		static let apiKey = "MwXJ5fvNp8pYEkWJqzUTQk5xql88XhtC"
	}

	// MARK: - Public Methods

	static func makeTrendingGifEndpoint(limit: Int, offset: Int) -> ApiEndpoint {
		ApiEndpoint(
			path: "trending",
			method: .get,
			queryParams: [
				"api_key": Constants.apiKey,
				"limit": String(limit),
				"offset": String(offset)
			]
		)
	}
}
