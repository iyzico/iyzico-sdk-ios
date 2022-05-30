//
//  UIImage-Extension.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 1.02.2021.
//

import Foundation
import UIKit
import Alamofire
import SVGKit

extension UIImageView {
    
    struct CachedImageModel: Codable {
        var imageUrl: String
        var svgImage: Data?
        var createdDate: Date
    }
    
    var imageCache: NSCache<AnyObject, AnyObject> {
        return NSCache<AnyObject, AnyObject>()
    }
    
    func setImage<T>(named: String, typeof: T) {
        self.image = UIImage(named: named, in: Bundle(for: type(of: typeof) as! AnyClass), compatibleWith: nil)
    }
    
    func setImageWithCaching(urlString: String? = nil, placeholderImage: UIImage,
                             completionHandler: @escaping (UIImage?) -> Void) {
//        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
//            self.image = imageFromCache
//            return
//        }
//
        guard let validatedUrlString = urlString else {
            self.image = placeholderImage
            return
        }
        
        
        var cachedImages: [CachedImageModel]? = DefaultsManager.get(forKey: DefaultsManager.DefaultKeys.cachedImages.rawValue)
//        let urlDate: Date = cachedImages?[validatedUrlString]?.1 ?? Date()
//        let dateInterval = urlDate.timeIntervalSinceNow * (-1)
        let cachedImage = cachedImages?.filter({ $0.imageUrl == validatedUrlString })
        if cachedImage?.count == 0 || cachedImage == nil {
            AF.request(validatedUrlString, method: .get).response { (responseData) in
                if let data = responseData.data {
                    if let safeImage = SVGKImage(data: data) {
                        if cachedImages == nil {
                            DefaultsManager.set([CachedImageModel(imageUrl: validatedUrlString,
                                                                  svgImage: safeImage.uiImage.pngData(),
                                                                  createdDate: Date())],
                                                forKey: DefaultsManager.DefaultKeys.cachedImages.rawValue)
                        } else {
                            cachedImages?.append(CachedImageModel(imageUrl: validatedUrlString,
                                                                  svgImage: safeImage.uiImage.pngData(), 
                                                                  createdDate: Date()))
                            DefaultsManager.set(cachedImages, forKey: DefaultsManager.DefaultKeys.cachedImages.rawValue)
                        }
                        completionHandler(safeImage.uiImage)
                    }
                    DispatchQueue.main.async { [weak self] in
                        if let imageToCache = UIImage(data: data){
//                            self?.imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                            self?.image = imageToCache
                            
                        } else if let downloadedSVGImage = SVGKImage(data: data) {
//                            self?.imageCache.setObject(downloadedSVGImage.uiImage, forKey: urlString as AnyObject)
                            self?.image = downloadedSVGImage.uiImage
                            completionHandler(downloadedSVGImage.uiImage)
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let safeData = cachedImage?[0].svgImage {
                    self.image = UIImage(data: safeData)
                    completionHandler(UIImage(data: safeData))
                }
            }
        }
    }
}

