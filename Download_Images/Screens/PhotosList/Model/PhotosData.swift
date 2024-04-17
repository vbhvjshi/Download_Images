//
//  UnsplashImageList.swift
//  Download_Images
//
//  Created by VAIBHAV JOSHI on 13/04/24.
//


import Foundation

// MARK: - WebPhoto
struct PhotosData: Codable {
    let page, perPage: Int?
    let photos: [WebPhoto]?
    let totalResults: Int?
    let nextPage, prevPage: String?

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case photos
        case totalResults = "total_results"
        case nextPage = "next_page"
        case prevPage = "prev_page"
    }
}

extension PhotosData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PhotosData.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        page: Int?? = nil,
        perPage: Int?? = nil,
        photos: [WebPhoto]?? = nil,
        totalResults: Int?? = nil,
        nextPage: String?? = nil,
        prevPage: String?? = nil
    ) -> PhotosData {
        return PhotosData(
            page: page ?? self.page,
            perPage: perPage ?? self.perPage,
            photos: photos ?? self.photos,
            totalResults: totalResults ?? self.totalResults,
            nextPage: nextPage ?? self.nextPage,
            prevPage: prevPage ?? self.prevPage
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Photo
struct WebPhoto: Codable {
    let id, width, height: Int?
    let url: String?
    let photographer: String?
    let photographerURL: String?
    let photographerID: Int?
    let avgColor: String?
    let src: Src?
    let liked: Bool?
    let alt: String?

    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer
        case photographerURL = "photographer_url"
        case photographerID = "photographer_id"
        case avgColor = "avg_color"
        case src, liked, alt
    }
}

// MARK: Photo convenience initializers and mutators

extension WebPhoto {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WebPhoto.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int?? = nil,
        width: Int?? = nil,
        height: Int?? = nil,
        url: String?? = nil,
        photographer: String?? = nil,
        photographerURL: String?? = nil,
        photographerID: Int?? = nil,
        avgColor: String?? = nil,
        src: Src?? = nil,
        liked: Bool?? = nil,
        alt: String?? = nil
    ) -> WebPhoto {
        return WebPhoto(
            id: id ?? self.id,
            width: width ?? self.width,
            height: height ?? self.height,
            url: url ?? self.url,
            photographer: photographer ?? self.photographer,
            photographerURL: photographerURL ?? self.photographerURL,
            photographerID: photographerID ?? self.photographerID,
            avgColor: avgColor ?? self.avgColor,
            src: src ?? self.src,
            liked: liked ?? self.liked,
            alt: alt ?? self.alt
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Src
struct Src: Codable {
    let original, large2X, large, medium: String?
    let small, portrait, landscape, tiny: String?

    enum CodingKeys: String, CodingKey {
        case original
        case large2X = "large2x"
        case large, medium, small, portrait, landscape, tiny
    }
}

// MARK: Src convenience initializers and mutators

extension Src {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Src.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        original: String?? = nil,
        large2X: String?? = nil,
        large: String?? = nil,
        medium: String?? = nil,
        small: String?? = nil,
        portrait: String?? = nil,
        landscape: String?? = nil,
        tiny: String?? = nil
    ) -> Src {
        return Src(
            original: original ?? self.original,
            large2X: large2X ?? self.large2X,
            large: large ?? self.large,
            medium: medium ?? self.medium,
            small: small ?? self.small,
            portrait: portrait ?? self.portrait,
            landscape: landscape ?? self.landscape,
            tiny: tiny ?? self.tiny
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
