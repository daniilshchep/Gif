//
//  UIImage.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import ImageIO
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

/// Extension for UIImage class
extension UIImage {

	// MARK: - Public Methods

	/// Get gif image from data
	static func getGif(from data: Data) -> UIImage? {
		guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

		var images = [CGImage]()
		var delays = [Double]()

		let count = CGImageSourceGetCount(source)
		for index in 0..<count {
			if let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) {
				images.append(cgImage)
			}

			let delaySeconds = UIImage.delayForImage(at: index, source: source)
			delays.append(delaySeconds)
		}

		let duration = delays.reduce(0, +)
		let frames = zip(images, delays).map { UIImage(cgImage: $0.0) }
		return UIImage.animatedImage(with: frames, duration: duration)
	}

	/// Converts image to data
	func converImageToData() -> Data? {
		let data = NSMutableData()

		guard let destination = CGImageDestinationCreateWithData(data, UTType.gif.identifier as CFString, 1, nil) else { return nil }

		let properties: [NSString: Any] = [kCGImagePropertyGIFDictionary as NSString: [kCGImagePropertyGIFDelayTime as NSString: 0.1]]

		if let cgImage = self.cgImage {
			CGImageDestinationAddImage(destination, cgImage, properties as CFDictionary)
			CGImageDestinationFinalize(destination)
		}

		return data as Data
	}

	// MARK: - Private Methods

	private static func delayForImage(at index: Int, source: CGImageSource) -> Double {
		let defaultDelay = 0.1
		guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any] else {
			return defaultDelay
		}

		let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any]
		let delay = gifProperties?[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double
			?? gifProperties?[kCGImagePropertyGIFDelayTime as String] as? Double
			?? defaultDelay

		return delay > 0 ? delay : defaultDelay
	}
}
