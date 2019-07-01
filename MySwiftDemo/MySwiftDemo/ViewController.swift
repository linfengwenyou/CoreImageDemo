//
//  ViewController.swift
//  MySwiftDemo
//
//  Created by fumi on 2019/6/28.
//  Copyright © 2019 rayor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
    func downsample(imageAt imageURL:URL, to pointSize:CGSize, scale:CGFloat) -> UIImage {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL,imageSourceOptions)!
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize:maxDimensionInPixels
        ] as CFDictionary
        
        let sourceSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
        
        return UIImage(cgImage: sourceSampledImage)
    }
    
    
    let searialQueue = DispatchQueue(label: "Decode queue")
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            searialQueue.async {
//                let downsampledImage = downsample("https://wwwwimage.png")
//                DispatchQueue.main.async {
//                    self.update()
//                }
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
    var index = 0
    var timer:Timer?
    var a:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor.white
//        runloopMonitor()
        
        let queue = DispatchQueue.init(label: "com.kang.song",attributes:[])

        print("this is start", Thread.current)

        queue.sync {
            print("this is a sync test", Thread.current)
        }

        queue.async {
            runloopMonitor()
            let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (timer) in
                print("timer value ---")
            })
            
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            
            let timer1 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                print("timer1 value ---")
            })
            
            RunLoop.current.add(timer1, forMode: RunLoop.Mode.common)
            
            RunLoop.current.run(until: Date.init(timeInterval: 10, since: Date.init()))
            
            
            print("this is a sync test", Thread.current)
        }

        print("this is finish", Thread.current)
    }
    
    
    @objc func testDemo() {
        print("this is a test", Thread.current)
    }
    
    
    
}

