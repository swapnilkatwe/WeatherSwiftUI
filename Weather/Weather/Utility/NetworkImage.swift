//
//  NetworkImage.swift
//  Weather
//
//  Created by SK on 26/11/23.
//

import SwiftUI

struct NetworkImage: View {
    @ObservedObject var loader: ImageLoader
    
    init(url: URL?) {
        loader = ImageLoader(url: url)
    }
    
    var body: some View {
        Group {
            if let data = loader.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if loader.isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
            }
        }
    }
}
