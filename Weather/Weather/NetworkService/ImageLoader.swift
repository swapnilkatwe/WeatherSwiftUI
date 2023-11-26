//
//  ImageViewModel.swift
//  Weather
//
//  Created by SK on 26/11/23.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    @Published public var imageData:Data
    @Published var isLoading = false

    init(url imageUrl: URL?) {
        self.imageData = Data()
        isLoading = true

        guard let url = imageUrl else {
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let unwrappedData = data {
                DispatchQueue.main.async {
                    self.imageData = unwrappedData
                    self.isLoading = false
                }
            }

        }.resume()
    }
}
