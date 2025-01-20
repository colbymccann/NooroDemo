//
//  SelectedCityView.swift
//  NooroDemo
//
//  Created by Colby McCann on 1/19/25.
//

import SwiftUI

struct SelectedCityView: View {
    var city: CityWithID
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https:\(city.condition.icon)")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 200, height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                case .failure:
                    Text("Failed to load image")
                @unknown default:
                    EmptyView()
                }
                
            }
            HStack {
                Text(city.name)
                    .font(.custom("Poppins-Regular", size: 30)).frame(alignment: .center)
                    .foregroundColor(Color(hex: "#2C2C2C"))
                Image("Vector")
                
            }
            Text(String(city.temperature))
                .font(.custom("Poppins-Regular", size: 70)).frame(alignment: .center)
                .foregroundColor(Color(hex: "#2C2C2C"))
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(hex: "#F2F2F2"))
                    .frame(width: 274, height: 75)
                    .padding(.horizontal, 57)
                HStack {
                    VStack{
                        Text("Humidity")
                            .font(.custom("Poppins-Regular", size: 12)).frame(alignment: .center)
                            .foregroundColor(Color(hex: "#C4C4C4"))
                        Text("\(city.humidity)%")
                            .font(.custom("Poppins-Regular", size: 15)).frame(alignment: .center)
                            .foregroundColor(Color(hex: "#9A9A9A"))
                    }
                    .padding(.leading, 90)
                    Spacer()
                    VStack {
                        Text("UV")
                            .font(.custom("Poppins-Regular", size: 12)).frame(alignment: .center)
                            .foregroundColor(Color(hex: "#C4C4C4"))
                        Text(String(Int(city.uvIndex)))
                            .font(.custom("Poppins-Regular", size: 15)).frame(alignment: .center)
                            .foregroundColor(Color(hex: "#9A9A9A"))
                    }
                    Spacer()
                    VStack {
                        Text("Feels Like")
                            .font(.custom("Poppins-Regular", size: 12)).frame(alignment: .center)
                            .foregroundColor(Color(hex: "#C4C4C4"))
                        Text(String(city.feelsLike))
                            .font(.custom("Poppins-Regular", size: 15)).frame(alignment: .center)
                            .foregroundColor(Color(hex: "#9A9A9A"))
                    }.padding(.trailing, 90)
                }
                
            }
            
            
        }.frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 30)
    }
}

#Preview {
    SelectedCityView(city:CityWithID.example)
}
