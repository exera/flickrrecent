//
//  ApiClient.swift
//  flickrrecent
//
//  Created by Ahmet Sancar on 13.07.2020.
//  Copyright © 2020 Ahmet Sancar. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire

class ApiClient {
  public static func recent(perpage: Int,page: Int,completionHandler: @escaping (_ res: FlickrResponse?, _ error:Error?) -> Void){
    let url = FlickrHelper.getRecentUrl(perpage: perpage, page: page)
    let decoder = JSONDecoder()
    
    Alamofire.request(url)
      .validate()
      .responseDecodableObject(keyPath: nil, decoder: decoder) { (res: DataResponse<FlickrResponse>) in
        if let r = res.result.value {
          completionHandler(r,nil)
          return
        }
        
        // some error occured
        let defErr = NSError(domain: "ApiClient", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
        completionHandler(nil,res.result.error ?? defErr) // we need to return err no matter
    }
  }
}
