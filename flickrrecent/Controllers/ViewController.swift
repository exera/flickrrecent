//
//  ViewController.swift
//  flickrrecent
//
//  Created by Ahmet Sancar on 12.07.2020.
//  Copyright © 2020 Ahmet Sancar. All rights reserved.
//

import UIKit
import SDWebImage
import UIScrollView_InfiniteScroll

class ViewController: UIViewController {

  private var cellIdentifier = "cell"
  private var itemCount = 3
  private var perpage = 20
  private var pages = 0
  private var currentpage = 1
  private var total = 0
  private var requestid: Int = 0
  private var items: [FlickrItem] = []
  
  
  @IBOutlet var collectionView: UICollectionView!
  var collectionViewLayout: UICollectionViewFlowLayout!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Flickr Recent"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    
    setItemSize()
    collectionView.delegate = self
    collectionView.dataSource = self
    
    
    collectionView.setShouldShowInfiniteScrollHandler { _ -> Bool in
      return self.currentpage != self.pages
    }
    collectionView.addInfiniteScroll { (collectionView) in
      self.fetch {
        self.collectionView.finishInfiniteScroll()
      }

    }
    
    // initial data
    collectionView.beginInfiniteScroll(true)
  }
  

  func fetch(_ completionHandler: (() -> Void)?){
    let newrequestid = requestid+1
    requestid = newrequestid
    let page = currentpage+1
    
    ApiClient.recent(perpage: perpage, page: page) { (res, err) in
      // ignore old requests
      guard newrequestid == self.requestid else {
        return
      }
      
      // some err occurred (network)
      guard let res = res else {
        self.showAlertWithError(completionHandler)
        return
      }
      
      // insert rows
      let newItems = res.photos.photo
      
      // create new index paths
      let photoCount = self.items.count
      let (start, end) = (photoCount, newItems.count + photoCount)
      let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
      
      // update data source
      self.items.append(contentsOf: newItems)
      self.currentpage = page
      self.pages = res.photos.pages
      
      // update ui
      self.collectionView.performBatchUpdates({
        self.collectionView?.insertItems(at: indexPaths)
        
      }) { (finished) in
        
        completionHandler?()
      }
    }
  }
  
  func showAlertWithError(_ completionHandler: (() -> Void)?) {
    let alert = UIAlertController(title: "Hata",message: "Beklenmedik bir hatayla karşılaşıldı",preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "İptal",style: .cancel,handler: nil))
    alert.addAction(UIAlertAction(title: "Tekrar Dene",style: .default,handler: { _ in self.fetch(completionHandler) }))
    self.present(alert, animated: true, completion: nil)
  }
  
  func setItemSize(){
    let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let interItemSpace = CGFloat(itemCount-1)*flow.minimumLineSpacing
    let itemWidth = (view.frame.size.width - interItemSpace) / CGFloat(itemCount)
    flow.itemSize = CGSize(width: itemWidth, height: itemWidth)
  }

}


extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    
    let item = items[indexPath.row]
    let vc = storyboard?.instantiateViewController(withIdentifier: "DetailController") as! DetailController
    vc.url = FlickrHelper.getImageUrl(farmid: item.farm, serverid: item.server, id: item.id, secret: item.secret)
    vc.title = item.title
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = items[indexPath.row]
    let imgUrl = FlickrHelper.getImageUrl(farmid: item.farm, serverid: item.server, id: item.id, secret: item.secret, thumb: true)

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FlickrCell
    cell.imageView.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "silver"))
    return cell
  }
  
  
}
