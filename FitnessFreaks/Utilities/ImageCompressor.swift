import UIKit

struct ImageCompressor {
    static func compressAndConvertToBase64(image: UIImage, quality: CGFloat = 0.7) -> String? {
        guard let imageData = image.jpegData(compressionQuality: quality) else {
            print("Failed to create initial JPEG data")
            return nil
        }

        // Check if the image size is under 500KB (500,000 bytes)
        // If not, try to compress more
        var compressedData = imageData
        var compressQuality = quality

        print("Initial image data size: \(compressedData.count) bytes")

        // Try to compress the image if it's larger than 500KB
        while compressedData.count > 500000 && compressQuality > 0.1 {
            compressQuality -= 0.1
            print("Compressing with quality: \(compressQuality)")
            if let newData = image.jpegData(compressionQuality: compressQuality) {
                compressedData = newData
                print("Compressed size: \(compressedData.count) bytes")
            }
        }

        // If the image is still larger than 500KB, try more aggressive resizing
        if compressedData.count > 500000 {
            print("Image still too large, resizing")
            var maxSize: CGFloat = 1000  // Start with 1000px as max dimension
            let originalSize = image.size

            // Try progressively smaller sizes until we get under 500KB
            while compressedData.count > 500000 && maxSize > 300 {
                // Calculate scale factor to reduce to maxSize
                let widthScale = maxSize / originalSize.width
                let heightScale = maxSize / originalSize.height
                let scale = min(widthScale, heightScale)

                // Only resize if we need to make it smaller
                if scale < 1.0 {
                    let newSize = CGSize(
                        width: originalSize.width * scale, height: originalSize.height * scale)

                    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
                    image.draw(in: CGRect(origin: .zero, size: newSize))
                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()

                    if let resizedImage = resizedImage,
                        let resizedData = resizedImage.jpegData(compressionQuality: 0.5)
                    {
                        compressedData = resizedData
                        print(
                            "Resized to \(maxSize)px and compressed to: \(compressedData.count) bytes"
                        )
                    }
                }

                // Reduce max size and try again if needed
                maxSize -= 200
            }

            // Last resort - most aggressive compression
            if compressedData.count > 500000 {
                print("Still exceeding 500KB, applying most aggressive compression")
                if let lastResortData = image.jpegData(compressionQuality: 0.01) {
                    compressedData = lastResortData
                    print("Final aggressive compression: \(compressedData.count) bytes")
                }
            }
        }

        let base64String = compressedData.base64EncodedString()
        print("Final Base64 string length: \(base64String.count) characters")

        // Prepend the content type as required by the API
        return "data:image/jpeg;base64,\(base64String)"
    }
}
