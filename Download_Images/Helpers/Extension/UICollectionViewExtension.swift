//
//  UICollectionViewExtension.swift
//  Download_Images
//
//  Created by VAIBHAV JOSHI on 13/04/24.
//

import Foundation
import UIKit

extension UICollectionView {
    func register(identifier: String) {
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: identifier)
    }
}


func processImages<T: Decodable>(data: Data, type: T.Type) {
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase // Use snake case keys in the JSON
        
        // Decode the JSON data into an array of objects of the specified type
        let objects = try decoder.decode(T.self, from: data)
        
        // Use the objects as needed
        print(objects)
    } catch {
        print("Error decoding JSON: \(error)")
    }
}
