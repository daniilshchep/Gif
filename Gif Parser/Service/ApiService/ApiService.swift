//
//  ApiService.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import Foundation

/// Protocol for API service
protocol ApiServiceProtocol {

	/// Send request to specific endpoint
	func sendRequest<T: Codable>(to endpoint: ApiEndpoint) async throws -> T?
}

/// Service for API calls
final class ApiService: ApiServiceProtocol {

	// MARK: - Constants

	private struct Constants {
		static let baseUrl = "https://api.giphy.com/v1/gifs/"
	}

	// MARK: - Private Properties

	private let jsonParser: JsonParserProtocol

	// MARK: - Init

	init(jsonParser: JsonParserProtocol) {
		self.jsonParser = jsonParser
	}

	// MARK: - Public Methods

	func sendRequest<T: Codable>(to endpoint: ApiEndpoint) async throws -> T? {
		guard var urlComponents = URLComponents(string: Constants.baseUrl + endpoint.path) else {
			return nil
		}

		if let queryParams = endpoint.queryParams {
			urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
		}

		guard let url = urlComponents.url else {
			return nil
		}

		var request = URLRequest(url: url)
		request.httpMethod = endpoint.method.rawValue

		do {
			let (data, _) = try await URLSession.shared.data(for: request)

			let object: T = try jsonParser.decodeData(data)
			return object
		} catch {
			throw error
		}
	}
}
