//
//  PhotoCell.swift
//  Download_Images
//
//  Created by VAIBHAV JOSHI on 13/04/24.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let identifier = "PhotoCell"
    @IBOutlet weak var imageView: UIImageView!
    private var isLoadingImage: Bool = false
    
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Show loader if not already loading an image
        if !isLoadingImage {
            Loader.shared.show(on: self)
            isLoadingImage = true
        }
        
        ImageDownloaderFactory.shared.getImage(for: url) { [weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.imageView.image = image
                } else {
                    // Set default image if no image is available
                    self?.imageView.image = UIImage(named: "no_image")
                }
                // Hide loader only if an image is received
                Loader.shared.hide()
                self?.isLoadingImage = false
            }
        }
    }
}
