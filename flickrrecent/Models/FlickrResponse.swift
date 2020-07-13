//
//  FlickrResponse.swift
//  flickrrecent
//
//  Created by Ahmet Sancar on 13.07.2020.
//  Copyright © 2020 Ahmet Sancar. All rights reserved.
//

import Foundation

struct FlickrResponse: Decodable {
  var photos: Photos
  var stat: String
  
  struct Photos: Decodable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: Int
    var photo: [FlickrItem]
  }
}

struct FlickrItem: Decodable {
  var id: String
  var owner: String
  var secret: String
  var server: String
  var farm: Int
  var title: String
  var ispublic: Int
  var isfriend: Int
  var isfamily: Int
}
