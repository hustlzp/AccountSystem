//
//  UIImage+Helper.swift
//  AccountSystem
//
//  Created by hustlzp on 2019/7/25.
//  Copyright © 2019 hustlzp. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     居中裁剪
     
     - parameter maxWidth: <#maxWidth description#>
     
     - returns: <#return value description#>
     */
    func centerCrop(_ maxWidth: CGFloat) -> UIImage? {
        return crop(1, maxWidth: maxWidth)
    }
    
    /**
     按长宽比裁剪
     
     - parameter aspectRatio: <#aspectRatio description#>
     - parameter maxWidth:    <#maxWidth description#>
     
     - returns: <#return value description#>
     */
    func crop(_ aspectRatio: CGFloat, maxWidth: CGFloat) -> UIImage? {
        var cropRect: CGRect
        let imageWidth = size.width
        let imageHeight = size.height
        
        if imageWidth > imageHeight {
            cropRect = CGRect(x: (imageWidth - imageHeight * aspectRatio) / 2.0, y: 0, width: imageHeight * aspectRatio, height: imageHeight)
        } else {
            cropRect = CGRect(x: 0, y: (imageHeight - imageWidth / aspectRatio) / 2.0, width: imageWidth, height: imageWidth / aspectRatio)
        }
        
        guard let croppedImage = crop(cropRect) else { return nil }
        
        if imageWidth <= maxWidth {
            return croppedImage
        }
        
        UIGraphicsBeginImageContext(CGSize(width: maxWidth, height: maxWidth / aspectRatio))
        croppedImage.draw(in: CGRect(x: 0, y: 0, width: maxWidth, height: maxWidth / aspectRatio))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /**
     裁剪为矩形
     
     - parameter rect: <#rect description#>
     
     - returns: <#return value description#>
     */
    func crop(_ rect: CGRect) -> UIImage? {
        var rectTransform: CGAffineTransform
        
        switch imageOrientation {
        case .left:
            rectTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2)).translatedBy(x: 0, y: -size.height)
        case .right:
            rectTransform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2)).translatedBy(x: -size.width, y: 0)
        case .down:
            rectTransform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi)).translatedBy(x: -size.width, y: -size.height)
        default:
            rectTransform = CGAffineTransform.identity
        }
        
        rectTransform = rectTransform.scaledBy(x: self.scale, y: self.scale)
        guard let imageRef = cgImage?.cropping(to: rect.applying(rectTransform)) else { return nil }
        
        return UIImage(cgImage: imageRef, scale: self.scale, orientation: imageOrientation)
    }
    
}
