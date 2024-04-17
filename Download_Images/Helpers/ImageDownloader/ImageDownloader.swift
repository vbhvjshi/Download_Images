//
//  ImageDownloader.swift
//  Download_Images
//
//  Created by VAIBHAV JOSHI on 14/04/24.
//

import Foundation
import UIKit

final class ImageDownloaderFactory {
    static let shared = ImageDownloaderFactory()
    
    private let cacheDirectory: URL = {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating cache directory: \(error)")
            }
        }
        
        return cacheDirectory
    }()
    
    private let imageCache = NSCache<NSURL, UIImage>()
    private let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
    
    func getImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check if the image is cached in memory
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            // Image found in cache, return it immediately
            completion(cachedImage)
        } else {
            // Image not found in memory cache, check disk cache
            let cachedImageURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
            if let cachedImageData = try? Data(contentsOf: cachedImageURL), let image = UIImage(data: cachedImageData) {
                // Image found in disk cache, store in memory cache and return
                imageCache.setObject(image, forKey: url as NSURL)
                completion(image)
            } else {
                // Image not found in cache, download asynchronously
                downloadQueue.async {
                    self.downloadImage(for: url, completion: completion)
                }
            }
        }
    }
    
    func downloadImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let group = DispatchGroup()
        group.enter()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { group.leave() }
            
            guard let data = data, let image = UIImage(data: data) else {
                // Error downloading or converting data to image
                completion(nil)
                return
            }
            
            // Compress image data with reduced quality
            if let compressedData = image.jpegData(compressionQuality: 0.3) {
                if let compressedImage = UIImage(data: compressedData) {
                    // Store compressed image in memory cache
                    self.imageCache.setObject(compressedImage, forKey: url as NSURL)
                    
                    // Store compressed image in disk cache
                    let cachedImageURL = self.cacheDirectory.appendingPathComponent(url.lastPathComponent)
                    do {
                        try compressedData.write(to: cachedImageURL)
                    } catch {
                        print("Error caching compressed image to disk: \(error)")
                    }
                    
                    // Return the compressed image
                    completion(compressedImage)
                } else {
                    // Failed to create compressed image
                    completion(nil)
                }
            } else {
                // Failed to compress image data
                completion(nil)
            }
        }.resume()
        
        group.wait() // Wait for the current download operation to finish before starting the next one
    }
}
