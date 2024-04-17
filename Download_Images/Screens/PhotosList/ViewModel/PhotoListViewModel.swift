//
//  PhotoListViewModel.swift
//  Download_Images
//
//  Created by VAIBHAV JOSHI on 13/04/24.
//

import Foundation

class PhotoListViewModel {
    var photos: [WebPhoto] = []
    
    func fetchPhotos(page: Int, completion: @escaping (Result<[WebPhoto], Error>) -> Void) {
        APIService.shared.fetchPhotos(page: page) { result in
            completion(result)
        }
    }
    
    func photoURL(for index: Int) -> String? {
        guard index < photos.count else { return nil }
        return photos[index].src?.original
    }
}
