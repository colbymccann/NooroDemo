//
//  ContentView.swift
//  NooroDemo
//
//  Created by Colby McCann on 1/17/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(hex: "#F2F2F2"))
                    
                    .opacity(1)
                
                HStack {
                    TextField("Search Location", text: $viewModel.query)
                        .onChange(of: viewModel.query) {
                            viewModel.citySelected = nil
                        }
                        .font(.custom("Poppins-Regular", size: 15))
                        .padding(.leading, 24)
                        .foregroundColor(viewModel.isSearching ? Color(hex: "#2C2C2C") : Color(hex: "#C4C4C4"))
                    Image("search_24px")
                        .padding(.trailing, 20)
                }

                
                
            }
            .frame(width: 336,height: 46)
            .padding(.top, 44)
            .padding(.leading, 24)
            .padding(.trailing, 24)
            .cornerRadius(16)
            if viewModel.citySelected != nil {
                SelectedCityView(city: viewModel.citySelected!)
            } else {
                if !viewModel.isSearching {
                    Text("No City Selected")
                                        .frame(width: 280, height: 60)
                                        .cornerRadius(12)
                                        .padding(.top, 240)
                                        .padding(.leading, 47)
                                        .padding(.trailing, 47)
                                        .multilineTextAlignment(.center)
                                        .font(.custom("Poppins-Regular", size: 30))
                    Text("Please Search For A City")
                                        .frame(width: 280, height: 19)
                                        .cornerRadius(12)
                                        .padding(.leading, 47)
                                        .padding(.trailing, 47)
                                        .multilineTextAlignment(.center)
                                        .font(.custom("Poppins-Regular", size: 15))
                } else {
                    List(viewModel.cityList) { result in
                        Button(action: {
                            viewModel.citySelected = result
                        }) {
                            SearchResultCardView(city: result)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .listStyle(PlainListStyle())
                    .listRowSeparator(.hidden)
                }
            }
        }.frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    MainView().environmentObject(ViewModel())
}


