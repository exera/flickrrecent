//
//  DetailController.swift
//  flickrrecent
//
//  Created by Ahmet Sancar on 13.07.2020.
//  Copyright © 2020 Ahmet Sancar. All rights reserved.
//

import UIKit
import ImageScrollView
import SDWebImage

class DetailController: UIViewController {
  
  var url: URL!
  
  @IBOutlet var imageScrollView: ImageScrollView!
  @IBOutlet var indicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // prevent overflow
    // when image is zoomed and pressed back button
    view.clipsToBounds = true
    
    indicator.startAnimating()
    SDWebImageManager.shared.loadImage(with: url, progress: nil) { (image, _, _, _, _, _) in
      // todo: stop indicator
      guard let image = image else {
        return
      }
      
      self.indicator.stopAnimating()
      self.imageScrollView.display(image: image)
    }
    
    
  }
}
