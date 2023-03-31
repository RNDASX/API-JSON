//
//  ApiModel.swift
//  Navigation
//
//  Created by Александр on 30.03.2023.
//

import Foundation

struct NewData: Decodable {

    var resultCount: Int
    var results: [Track]

}


struct Track: Decodable {

    var trackName: String?
    var artistName: String? // author
    var collectionId: Int? // likes
    var trackId: Int? // views
    var artworkUrl60: String? // image
    var collectionCensoredName: String? // description

}
