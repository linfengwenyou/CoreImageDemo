//
//  ImageWaterfallLayout.swift
//  MySwiftDemo
//
//  Created by LIUSONG on 2019/7/5.
//  Copyright © 2019 rayor. All rights reserved.
//

import UIKit

class ImageWaterfallLayout: UICollectionViewLayout {

	// 瀑布流的展示方式
	
	// 列数
	var maxColumnCount = 4
	var padding:CGFloat = 10
	var maxColumnHeights = [CGFloat]()
	var inset:UIEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 10)
	let ScreenWidth = UIScreen.main.bounds.size.width
	
	// 图片信息，数据源信息
	var images:[UIImage] = [UIImage]()
	
	
	override var collectionViewContentSize: CGSize {
		var maxY = maxColumnHeights.first!
		for index in 1..<maxColumnCount {
			if maxY < maxColumnHeights[index] {
				maxY = maxColumnHeights[index]
			}
		}
		return CGSize.init(width: ScreenWidth, height: maxY)
	}
	
	var attributes = [UICollectionViewLayoutAttributes]()
	
	override func prepare() {
		super.prepare()
		print("prepare")
		
		self.attributes.removeAll()
		
//		配置maxColumnHeight
		for _ in 0..<maxColumnCount {
			maxColumnHeights.append(0.0)
		}
		
		
		guard let numbers = self.collectionView?.numberOfItems(inSection: 0) else {
			return ;
		}
		
		for index in 0..<numbers {
			if let attr = self .layoutAttributesForItem(at: IndexPath.init(row: index, section: 0)) {
				self.attributes.append(attr)
			}
		}
		
	}
	
	/** 返回所有的元素信息 */
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		print("layoutAttributesForElements")
		// 需要根据attr返回一个字符串
		return self.attributes
	}
	
	/** 返回每一个元素的布局信息 */
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		let attr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
		print("layoutAttributesForItem")
		// 初始 x  y
//		找出最小y
		var minY = maxColumnHeights.first!
		var columIndex = 0
		for i in 1..<maxColumnCount {
			if minY > maxColumnHeights[i] {
				minY = maxColumnHeights[i]
				columIndex = i
			}
			
		}
		
		let value:CGFloat = CGFloat(maxColumnCount)
		let width = (ScreenWidth - padding * (value+1)) / value
		
		let image = images[indexPath.row]
		
		
		let x:CGFloat = padding + (padding + width) * CGFloat(columIndex)
		let y:CGFloat = minY + inset.top
		let height = width / image.size.width * image.size.height
		
		attr.frame = CGRect.init(x: x, y: y, width: width, height: height)
		
		maxColumnHeights[columIndex] = attr.frame.maxY
		
		
		return attr
	}
	
}
