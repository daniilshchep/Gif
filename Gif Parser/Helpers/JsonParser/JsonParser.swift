//
//  JsonParser.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import Foundation

/// Protocol for JSON data parser
protocol JsonParserProtocol {

	/// Decode JSON data
	func decodeData<T: Codable>(_ data: Data) throws -> T
}

/// Parser for JSON data
final class JsonParser: JsonParserProtocol {

	// MARK: - Public Methods

	func decodeData<T: Codable>(_ data: Data) throws -> T {
		try JSONDecoder().decode(T.self, from: data)
	}
}
