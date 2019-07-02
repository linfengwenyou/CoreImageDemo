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
        
//        let queue = DispatchQueue.init(label: "com.kang.song",attributes:DispatchQueue.Attributes.concurrent)
        let queue = DispatchQueue.global(qos: DispatchQoS.background.qosClass)

        print("this is start", Thread.current)

        //TODO: 可能图片顺序混乱
        
        queue.sync {
            print("this is a sync test", Thread.current)
            queue.async {
                print("this is async test", Thread.current)
            }
        }
        
        
        

//        queue.async {
//            runloopMonitor()
//            let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (timer) in
//                print("timer value ---")
//            })
//
//            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
//
//            let timer1 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
//                print("timer1 value ---")
//            })
//
//            RunLoop.current.add(timer1, forMode: RunLoop.Mode.common)
//
//            RunLoop.current.run(until: Date.init(timeInterval: 10, since: Date.init()))
//
//
//            print("this is a sync test", Thread.current)
//        }

        print("this is finish", Thread.current)
        
        let iamgeView = UIImageView.init(frame: self.view.bounds)
        self.view.addSubview(iamgeView)
        
//        iamgeView.image = self.snapTwoImages(image1, image2: image2)
        var images = [UIImage]()
        for i in 0...1000 {
            if let image = UIImage.init(named: "\(i)") {
                images.append(image)                
            }
        }
        
        
//        图片存储本地
        queue.async {
            self.snapMoreImages(images)
        }
        
    }
    
    
    @objc func testDemo() {
        print("this is a test", Thread.current)
    }
    
    
    func snapMoreImages(_ images:[UIImage]) {
        // 开启上下文
        var totalHeight = UIScreen.main.bounds.size.height * 40
        let width = UIScreen.main.bounds.size.width
        
        
        // 1. 先将数组内容进行子级分组
        
        var imageArrs = [[UIImage]]()
        var totalHeights = [CGFloat]()
        var origY:CGFloat = 0
        var tmpImages = [UIImage]()
        for image in images {
            let height = width / image.size.width * image.size.height;
            if height + origY > totalHeight {
                imageArrs.append(tmpImages)
                totalHeights.append(origY)
                tmpImages = [UIImage]()
                origY = 0
            }
            origY = origY + height
            tmpImages.append(image)
        }
        
        totalHeights.append(origY)
        imageArrs.append(tmpImages)
//        通过组的方式进行处理
        
//        let group = DispatchGroup.init()
        let conQueue = DispatchQueue.init(label: "com.concurrent.song",  attributes: DispatchQueue.Attributes.concurrent)
        
        for (index, images) in imageArrs.enumerated() {
            conQueue.async {
                UIGraphicsBeginImageContext(CGSize.init(width: width, height: totalHeights[index]))
                // 画图
                var orighinY:CGFloat = 0
                for image in images {
                    let height = width / image.size.width * image.size.height;
                    image.draw(in: CGRect.init(x: 0, y: orighinY, width: width, height: height))
                    orighinY = height + orighinY
                }
                
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.saveImage(image: image!, imageName: "testDemo\(index).jpg")
            }
            
        }
        
      
    }
    
    
    func saveImage(image:UIImage, imageName:String) {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        
        let fileName = path + "/" + imageName
        print(fileName)
        
        // 写入路径
        let isSuccess = FileManager.default.createFile(atPath: fileName, contents: image.jpegData(compressionQuality: 0.8))
        if isSuccess {
            print("文件写入成功")
        } else {
            print("文件写入失败")
        }
    }
    
}

