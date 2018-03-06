//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by Faisal Alkhotaifi on 3/5/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class{
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  
  //This keeps a reference to the delegate.
  weak var delegate: PinterestLayoutDelegate!
  
  fileprivate var numberOfColumns = 2
  fileprivate var cellPadding: CGFloat = 6
  
  fileprivate var cache = [UICollectionViewLayoutAttributes]()
  
  fileprivate var contentHeight: CGFloat = 0
  
  fileprivate var contentWidth: CGFloat{
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  
  override var collectionViewContentSize: CGSize{
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  //This method is called whenever a layout operation is about to take place
  override func prepare() {
    guard cache.isEmpty == true, let collectionView = collectionView else {
      return
    }
    
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffest = [CGFloat]()
    
    for column in 0..<numberOfColumns{
      xOffest.append(CGFloat(column) * columnWidth)
    }
    
    var column = 0
    var yOffest = [CGFloat](repeating: 0, count: numberOfColumns)
    
    for item in 0..<collectionView.numberOfItems(inSection: 0){
      let indexPath = IndexPath(item: item, section: 0)
      
      let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffest[column], y: yOffest[column], width: columnWidth, height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      
      cache.append(attributes)
      
      contentHeight = max(contentHeight, frame.maxY)
      yOffest[column] = yOffest[column] + height
      
      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    for attributes in cache{
      if attributes.frame.intersects(rect){
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  
}














