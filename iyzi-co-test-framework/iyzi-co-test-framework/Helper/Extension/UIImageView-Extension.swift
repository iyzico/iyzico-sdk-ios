//
//  UIImage-Extension.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 1.02.2021.
//

import Foundation
import UIKit
import Alamofire
import SVGKit

extension UIImageView {
    
    var imageCache: NSCache<AnyObject, AnyObject> {
        return NSCache<AnyObject, AnyObject>()
    }
    
    func setImage<T>(named: String, typeof: T) {
        self.image = UIImage(named: named, in: Bundle(for: type(of: typeof) as! AnyClass), compatibleWith: nil)
    }
    
    func setImageWithCaching(urlString: String? = nil, placeholderImage: UIImage)  {
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        
        guard let validatedUrlString = urlString else {
            self.image = placeholderImage
            return
        }
        
        AF.request(validatedUrlString, method: .get).response { (responseData) in
            if let data = responseData.data {
                DispatchQueue.main.async { [weak self] in
                    if let imageToCache = UIImage(data: data){
                        self?.imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                        self?.image = imageToCache
                    } else if let downloadedSVGImage = SVGKImage(data: data) {
                        self?.imageCache.setObject(downloadedSVGImage.uiImage, forKey: urlString as AnyObject)
                        self?.image = downloadedSVGImage.uiImage
                    }
                }
            }
        }
    }
}

