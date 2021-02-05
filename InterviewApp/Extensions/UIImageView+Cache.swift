//
//  UIImageView+Cache.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

extension UIImageView {
    public func loadImage(fromURL url: URL) {
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print(error)
                    }
                    guard let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }.resume()
            }
        }
    }
}
