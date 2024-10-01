//
//  GifCell.swift
//  Gif Parser
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import UIKit

/// Cell for gif display
final class GifCell: UICollectionViewCell {

	// MARK: - Public Properties

	static let identifier = "GifCell"

	// MARK: - UI Components

	private let imageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		return view
	}()

	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	/// Setup content for cell
	func setupContent(image: UIImage?) {
		imageView.image = image
	}

	// MARK: - Private Methods

	private func setupViews() {
		[imageView].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(view)
		}

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		])
	}
}
