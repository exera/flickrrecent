//
//  FlickrHelper.swift
//  flickrrecent
//
//  Created by Ahmet Sancar on 12.07.2020.
//  Copyright © 2020 Ahmet Sancar. All rights reserved.
//

import Foundation

class FlickrHelper {
  static let apiKey: String = "3b4f06733cc7b48645a63e9b1f8cd1f0"
  
  
  // https://www.flickr.com/services/api/misc.urls.html
  static func getImageUrl(farmid: Int,serverid: String,id: String,secret: String,thumb: Bool=false) -> URL {
    let suffix = thumb ? "q" : "b"
    return URL(string: "https://farm\(farmid).staticflickr.com/\(serverid)/\(id)_\(secret)_\(suffix).jpg")!
  }
  
  static func getRecentUrl(perpage: Int,page: Int) -> URL {
    return URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(apiKey)&per_page=\(perpage)&page=\(page)&format=json&nojsoncallback=1")!
  }
}
