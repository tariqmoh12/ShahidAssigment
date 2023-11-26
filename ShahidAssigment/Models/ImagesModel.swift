// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let imagesModel = try? JSONDecoder().decode(ImagesModel.self, from: jsonData)

import Foundation
import RealmSwift
// MARK: - ImagesModel
class ImagesModel: Object, Codable {
    @Persisted var data: List<ImageModel>
    @Persisted var pagination: Pagination?
}

class ImageModel: Object, Codable {
    @Persisted(primaryKey: true) @objc dynamic var id: String = ""
      @Persisted @objc dynamic var embed_url: String?
      @Persisted @objc dynamic var title: String?
      @Persisted @objc dynamic var images: Images?

      enum CodingKeys: String, CodingKey {
          case id, embed_url, title, images
      }
}

// MARK: - Images
class Images: Object, Codable {
    @Persisted var hd: DownsizedSmall?
    @Persisted var downsized: The480_WStill?


    enum CodingKeys: String, CodingKey {
        case hd
        case downsized

    }
}

// MARK: - The480_WStill
class The480_WStill:Object, Codable {
    @Persisted var url: String?
    @Persisted  var width: String?
    @Persisted  var height: String?
    @Persisted  var size: String?
}

// MARK: - DownsizedSmall
class DownsizedSmall:Object, Codable {
    @Persisted var height: String?
    @Persisted var mp4: String?
    @Persisted var mp4Size: String?
    @Persisted var width: String?

    enum CodingKeys: String, CodingKey {
        case height, mp4
        case mp4Size
        case width
    }
}

// MARK: - Pagination
class Pagination: Object, Codable {
    @Persisted var count: Int?
    @Persisted var offset: Int?
    @Persisted var nextCursor: Int?


    enum CodingKeys: String, CodingKey {
        case count, offset
        case nextCursor
    }
}
