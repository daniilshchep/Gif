//
//  ApiEndpoint.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

/// Endpoint for API requests
struct ApiEndpoint {

	/// Path (without base part)
	let path: String

	/// Method type
	let method: ApiRequestMethod

	/// Query params
	let queryParams: [String: String]?
}
