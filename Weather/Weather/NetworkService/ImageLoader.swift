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
        guard #available(iOS 15.0, *) else {
            getData(url: url)
            return
        }
    }

    func getData(url: URL) {
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
