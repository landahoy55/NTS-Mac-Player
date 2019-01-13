//
//  Networking.swift
//  NTS Player
//
//  Created by P Malone on 26/11/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

//Making use of online networking.

// To parse the JSON, add this file to your project and do:
//
//   let nts = try? newJSONDecoder().decode(Nts.self, from: jsonData)
//
// To read values from URLs:
//
//   let task = URLSession.shared.ntsTask(with: url) { nts, response, error in
//     if let nts = nts {
//       ...
//     }
//   }
//   task.resume()

import Foundation

struct NTS: Codable {
    let results: [Result]
    let links: [Link]
}

struct Link: Codable {
    let rel: String
    let href: String
    let type: String
}

struct Result: Codable {
    let channelName: String
    let now, next: Next
    
    enum CodingKeys: String, CodingKey {
        case channelName = "channel_name"
        case now, next
    }
}

struct Next: Codable {
    let broadcastTitle: String
    let startTimestamp, endTimestamp: Date
    let embeds: NextEmbeds
    let links: [Link]
    
    enum CodingKeys: String, CodingKey {
        case broadcastTitle = "broadcast_title"
        case startTimestamp = "start_timestamp"
        case endTimestamp = "end_timestamp"
        case embeds, links
    }
}

struct NextEmbeds: Codable {
    let details: Details
}

struct Details: Codable {
    let status: String
    let updated: Date
    let name, description, descriptionHTML: String
    let facebook, twitter: String?
    let website: JSONNull?
    let moods, genres: [Genre]
    let locationShort, locationLong, intensity: String?
    let media: Media
    let episodeAlias: String?
    let showAlias: String
    let broadcast: Date?
    let mixcloud: String?
    let embeds: DetailsEmbeds
    let links: [Link]
    let timeslot, frequency, type: String?
    
    enum CodingKeys: String, CodingKey {
        case status, updated, name, description
        case descriptionHTML = "description_html"
        case facebook, twitter, website, moods, genres
        case locationShort = "location_short"
        case locationLong = "location_long"
        case intensity, media
        case episodeAlias = "episode_alias"
        case showAlias = "show_alias"
        case broadcast, mixcloud, embeds, links, timeslot, frequency, type
    }
}

struct DetailsEmbeds: Codable {
}

struct Genre: Codable {
    let id, value: String
}

struct Media: Codable {
    let backgroundLarge, backgroundMediumLarge, backgroundMedium, backgroundSmall: String
    let backgroundThumb, pictureLarge, pictureMediumLarge, pictureMedium: String
    let pictureSmall, pictureThumb: String
    
    enum CodingKeys: String, CodingKey {
        case backgroundLarge = "background_large"
        case backgroundMediumLarge = "background_medium_large"
        case backgroundMedium = "background_medium"
        case backgroundSmall = "background_small"
        case backgroundThumb = "background_thumb"
        case pictureLarge = "picture_large"
        case pictureMediumLarge = "picture_medium_large"
        case pictureMedium = "picture_medium"
        case pictureSmall = "picture_small"
        case pictureThumb = "picture_thumb"
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
  //      let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

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

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func ntsTask(with url: URL, completionHandler: @escaping (NTS?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
