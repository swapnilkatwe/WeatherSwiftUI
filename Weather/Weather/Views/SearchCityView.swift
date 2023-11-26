//
//  SearchCityView.swift
//  Weather
//
//  Created by SK on 26/11/23.
//

import SwiftUI

struct SearchCityView: View {
    @ObservedObject var weatherViewModel: WeatherViewModel
    @State private var searchedCity = ""
    
    var body: some View {
        HStack {
            TextField("Enter city here", text: $searchedCity)
                .padding(.leading, 50)
                .font(.system(size: Constants.Font.mediumSize))
            Button {
                weatherViewModel.city = searchedCity
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                        .fill(Constants.Colors.darkBlueColor.opacity(0.4))
                        .frame(width: 30, height: 30)
                    Image(systemName: Constants.Images.magnifyingGlass)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
        }
        .foregroundColor(.white)
        .padding()
        .background(ZStack (alignment: .leading) {
            Image(systemName: Constants.Images.location)
                .foregroundColor(.blue)
                .padding(.leading, Constants.Dimensions.defaultPadding)
            RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: Constants.Colors.gradientSerchMenu),
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
        })
    }
}

struct SearchCityView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCityView(weatherViewModel: WeatherViewModel())
    }
}
