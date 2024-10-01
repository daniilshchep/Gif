//
//  GifCacheService.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import UIKit

/// Protocol for gif caching service
protocol GifCacheServiceProtocol {

	/// Get image from cache if exists
	func getGif(for key: String) -> Data?

	/// Save image to cache
	func saveGif(_ gifData: Data, for key: String)
}

/// Manager for gif caching
final class GifCacheService: GifCacheServiceProtocol {

	// MARK: - Private Properties

	private let fileManager = FileManager.default
	private lazy var cacheDirectory: URL = {
		if let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
			return cachesDirectory.appendingPathComponent("GifCache")
		}
		return URL(fileURLWithPath: "")
	}()

	// MARK: - Initializer

	init() {
		createCacheDirectoryIfNeeded()
	}

	// MARK: - Public Methods

	func getGif(for key: String) -> Data? {
		let safeKey = safeFileName(for: key)
		let filePath = cacheDirectory.appendingPathComponent(safeKey).path

		guard fileManager.fileExists(atPath: filePath) else {
			return nil
		}

		do {
			let gifData = try Data(contentsOf: URL(fileURLWithPath: filePath))
			return gifData
		} catch {
			return nil
		}
	}

	func saveGif(_ gifData: Data, for key: String) {
		let safeKey = safeFileName(for: key)
		let filePath = cacheDirectory.appendingPathComponent(safeKey).path
		try? gifData.write(to: URL(fileURLWithPath: filePath))
	}

	// MARK: - Private Methods

	private func createCacheDirectoryIfNeeded() {
		if !fileManager.fileExists(atPath: cacheDirectory.path) {
			try? fileManager.createDirectory(
				at: cacheDirectory,
				withIntermediateDirectories: true,
				attributes: nil
			)
		}
	}

	private func safeFileName(for key: String) -> String {
		let invalidCharacters = CharacterSet(charactersIn: "/\\?&")
		let newKey = key.components(separatedBy: invalidCharacters).joined(separator: "_")
		return "\(newKey).gif"
	}
}
