//
//  GifModel.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

/// Model for gifs
struct GifModel: Codable {

	/// Array of gifs objects
	let data: [GifObject]

	enum CodingKeys: CodingKey {
		case data
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.data = try container.decode([GifObject].self, forKey: .data)
	}
}

/// Object for gif
struct GifObject: Codable {

	/// Gif images
	let images: GifImagesModel

	enum CodingKeys: CodingKey {
		case images
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.images = try container.decode(GifImagesModel.self, forKey: .images)
	}
}

/// Gif images
struct GifImagesModel: Codable {

	/// Original size image
	let original: GifImageObject

	enum CodingKeys: CodingKey {
		case original
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.original = try container.decode(GifImageObject.self, forKey: .original)
	}
}

/// Gif image object
struct GifImageObject: Codable {

	/// Image url
	let url: String?

	enum CodingKeys: CodingKey {
		case url
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.url = try container.decodeIfPresent(String.self, forKey: .url)
	}
}
