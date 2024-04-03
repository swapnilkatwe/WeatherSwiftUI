//
//  NetworkImage.swift
//  Weather
//
//  Created by SK on 26/11/23.
//

import SwiftUI

struct NetworkImage: View {
    @ObservedObject var loader: ImageLoader
    var url: URL?
    init(url: URL?) {
        self.url = url
        loader = ImageLoader(url: url) // iOS version check added in ImageLoader to prevent extra api call
    }
    
    var body: some View {
        Group {
            if #available(iOS 15.0, *) {
                AsyncImage(url: self.url) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                    } else {
                        ProgressView()
                    }
                }
            } else {
                if let uiImage = UIImage(data: loader.imageData) {
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
}

struct NetworkImage_Previews: PreviewProvider {
    static var previews: some View {
        NetworkImage(url: URL(string: ""))
    }
}
