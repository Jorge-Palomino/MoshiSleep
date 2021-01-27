//
//  ImageLoader.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import Foundation
import UIKit

class ImageLoader {
    
    static let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 150_000_000
        return cache
    }()
    static func downloadImage(withURL url:URL, completion: @escaping(_ image: UIImage?)->()){
        let dataTask = URLSession.shared.dataTask(with:url) { data, responseURL, error in
            var downloadedImage:UIImage?
            
            if let data = data{
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }
    static func getImage(withURL url:URL, completion: @escaping(_ image: UIImage?)->()){
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        }else {
            downloadImage(withURL: url, completion: completion)
        }
    }
}

class CustomImageView: UIImageView {
    var imageUrlString: String?
    var loading: UIActivityIndicatorView?
    var defaultPicture: UIImage?
    
    func loadImageUsingUrlString(urlString: String) {
        self.image = nil
        imageUrlString = urlString
        self.loading?.isHidden = false
        self.loading?.startAnimating()
        let url = URL(string: urlString)
        ImageLoader.getImage(withURL: url!) { image in
            DispatchQueue.main.async {
                if self.imageUrlString == urlString {
                    if image != nil || self.defaultPicture == nil {
                        self.image = image
                    }else {
                        self.image = self.defaultPicture
                    }
                    self.loading?.stopAnimating()
                    self.loading?.isHidden = true
                }
            }
        }
    }
}


