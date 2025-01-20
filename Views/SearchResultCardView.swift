//
//  SearchResultCard.swift
//  NooroDemo
//
//  Created by Colby McCann on 1/19/25.
//

import SwiftUI

struct SearchResultCardView: View {
    var city: CityWithID
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(hex: "#F2F2F2"))
                .frame(width: 336, height: 117)
                .padding(.leading, 24)
                .padding(.trailing, 24)
            
            HStack {
                VStack {
                    Group {
                        Text(city.name)
                            
                            .font(.custom("Poppins-Regular", size: 20))
                            .foregroundColor(Color(hex: "#2C2C2C"))
                        Text(city.region)
                            .font(.custom("Poppins-Regular", size: 20))
                            .foregroundColor(Color(hex: "#2C2C2C"))
                        Text(String(city.temperature))
                            .font(.custom("Poppins-Regular", size: 44))
                            .foregroundColor(Color(hex: "#2C2C2C"))
                        
                    }
                    .padding(.leading, 55)
                    
                    
                }
                Spacer()
                AsyncImage(url: URL(string: "https:\(city.condition.icon)")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 200, height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                    case .failure:
                        Text("Failed to load image")
                    @unknown default:
                        EmptyView()
                    }
                    
                }
                    
                    .frame(width:100, height:100)
                    .padding(.trailing, 55)
            }
            
            
        }
    }
}

#Preview {
    SearchResultCardView(city:CityWithID.example)
}
