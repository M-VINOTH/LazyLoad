#if os(iOS) || os(tvOS)
import UIKit
public class LazyLoad: UIImageView  {
    //MARK: Parameters
    private var cachedImage:  UIImage? {
        return ImageCache.sharedCache.object(forKey: self.imageURL as AnyObject) as? UIImage
    }
    
    
    private struct AssociatedKeys {
        static var imageURLKey = "nsh_imageURLKey"
        static var canShowLoaderKey = "nsh_canShowLoaderKey"
    }
    
    public func loadImage(from url: String,placeHolder: UIImage? = nil, completion:((_ image: UIImage) -> Void)? = nil){
        if let URL:NSURL = NSURL(string: url) {
            self.imageURL = url
            
            if cachedImage != nil {
                if completion != nil {
                    completion!(cachedImage!)
                } else {
                    self.image = cachedImage
                }
                self.imageURL = nil
                return
            }
            
            let task = URLSession.shared.dataTask(with: URL as URL) { (data, response, error) in
                if error == nil {
                    if let imageData = data {
                        if let myImage = UIImage(data: imageData) {
                            
                            if self.imageURL == url {
                                ImageCache.sharedCache.setObject(myImage, forKey: self.imageURL as AnyObject, cost: imageData.count)
                                
                                // update the ui with the downloaded image
                                DispatchQueue.main.async {
                                    
                                    
                                    // notify the completion handler if user wish to handle the downloaded image. Otherwise just load the image with alpha animation
                                    if completion != nil {
                                        completion!(myImage)
                                    } else {
                                        self.alpha = 0
                                        self.image = myImage
                                        UIView.animate(withDuration: 0.3, animations: {
                                            self.alpha = 1
                                        })
                                    }
                                }
                            }else {
                                
                            }
                        } else {
                            
                        }
                        
                        self.imageURL = nil
                    } else {
                        
                    }
                }
            }
            
            task.resume()
            
            
        }
    }
    
    private var imageURL: String! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.imageURLKey) as? String
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.imageURLKey,
                    newValue as NSString?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}

class ImageCache {
    static let sharedCache: NSCache = { () -> NSCache<AnyObject, AnyObject> in
        let cache = NSCache<AnyObject, AnyObject>()
        cache.name = "MyImageCache"
        cache.countLimit = 100 // Max 50 images in memory.
        cache.totalCostLimit = 50*1024*1024 // Max 10MB used.
        return cache
    }()
}
#endif

