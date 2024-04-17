//
//  APIService.swift
//  Download_Images
//
//  Created by VAIBHAV JOSHI on 13/04/24.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    private let baseURL = "https://api.pexels.com/v1/curated?"
    private let clientID = "l2ovzA1c3TFUhYZx4Ar4Y4cNA62tvEp3jzmzquL5rko6Bm7h5z9spqJ1"
        
    func fetchPhotos(page: Int, perPage: Int = 80, orderBy: String = "latest", completion: @escaping (Result<[WebPhoto], Error>) -> Void) {
        print("Current Page========= \(page) ===========")
        let urlString = baseURL + "per_page=\(perPage)&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(clientID, forHTTPHeaderField: "Authorization") // Change here
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(NetworkError.networkError))
                return
            }
            
            do {
                
                //let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                let photos = try PhotosData(data: data)
                
                let decoder = JSONDecoder()
                // let pexelsResponse = try decoder.decode(Photo.self, from: data)
                completion(.success(photos.photos ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func handleFetchPhotosResult(result: Result<[WebPhoto], Error>) {
        switch result {
        case .success(let photos):
            // Handle successful fetching of photos
            print("Fetched \(photos.count) photos.")
        case .failure(let error):
            // Handle error
            print("Error fetching photos: \(error.localizedDescription)")
        }
    }
}

// Enum to represent network errors
enum NetworkError: Error {
    case invalidURL
    case networkError
}
