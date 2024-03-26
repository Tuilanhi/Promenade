//
//  GIFImageView.swift
//  Frontend
//
//  Created by Nhi Vu on 3/26/24.
//

import SwiftUI
import UIKit
import ImageIO
import UniformTypeIdentifiers


struct GIFImageView: UIViewRepresentable {
    var imageName: String

    func makeUIView(context: Self.Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        if let gifImage = UIImage.gifImageWithName(imageName) {
            imageView.image = gifImage
        }
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: UIViewRepresentableContext<GIFImageView>) {
        // GIF images do not need to be updated with state changes
    }
}

extension UIImage {
    class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif"),
              let imageData = try? Data(contentsOf: bundleURL) else {
            print("This image named \"\(name)\" does not exist or cannot be loaded!")
            return nil
        }
        
        let options: [String: Any] = [
            kCGImageSourceShouldCache as String: true,
            kCGImageSourceTypeIdentifierHint as String: UTType.gif.identifier
        ]

        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, options as CFDictionary) else {
            return nil
        }

        let imageCount = CGImageSourceGetCount(imageSource)
        var images = [UIImage]()
        var gifDuration = 0.0

        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(imageSource, i, nil) {
                let delaySeconds = delayForImageAtIndex(Int(i), source: imageSource)
                gifDuration += delaySeconds
                images.append(UIImage(cgImage: image))
            }
        }

        return UIImage.animatedImage(with: images, duration: gifDuration)
    }

    class func delayForImageAtIndex(_ index: Int, source: CGImageSource) -> Double {
        var delay = 0.1

        if let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as NSDictionary?,
           let gifProperties = cfProperties[kCGImagePropertyGIFDictionary as String] as? NSDictionary {
            let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double
            ?? gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double
            ?? delay // Default to 0.1 if not found

            delay = max(delayTime, 0.1) // Ensure a minimum delay of 0.1s
        }

        return delay
    }

}

