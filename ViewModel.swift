//
//  WeatherSearchCenter.swift
//  NooroDemo
//
//  Created by Colby McCann on 1/17/25.
//

import Foundation
import Combine
import SwiftUI

func parseSearch(json: Data) -> [SearchResult] {
    let decoder = JSONDecoder()
    do {
        return try decoder.decode([SearchResult].self, from: json)
    } catch {
        print("Error parsing json: \(error)")
        return []
    }
}

func parseCity(json: Data) -> City? {
    let decoder = JSONDecoder()
    do {
        return try decoder.decode(City.self, from: json)
    } catch {
        print("Unable to parse data into city info \(error)")
        return nil
    }
}

@MainActor
class ViewModel: ObservableObject {
    @Published var searchResults: [SearchResult] = []
    @Published var cityList: [CityWithID] = []
    @Published var query: String = ""
    @Published var isSearching = false
    @Published var citySelected: CityWithID? {
        didSet {
            handleCitySelectionChange()
        }
    }
    private var cancellables = Set<AnyCancellable>()
    private var intermediate: [CityWithID] = []
    private var isRestoring = false
    let searchURLBase = "https://api.weatherapi.com/v1/search.json?key="
    let weatherURLBase = "https://api.weatherapi.com/v1/current.json?key="
    private var apiKey = ""
    let savedCityKey = "savedCity"
    
    init() {
        restoreSavedCity()
        if let bundleApiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
            apiKey = bundleApiKey
        }
        $query
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.isSearching = !query.isEmpty
                Task { await self?.search(with: query) }
            }
            .store(in: &cancellables)
    }
    
    func search(with query: String) async {
        let finishedURL = searchURLBase + apiKey + "&q=" + query
        if let url = URL(string: finishedURL) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                searchResults = parseSearch(json: data)
                intermediate = []
                for result in searchResults {
                    if let city = await getWeather(with: result.id) {
                        let cityWithID = CityWithID(name: result.name, region: result.region, id: result.id, temperature: city.temperature, condition: city.condition, humidity: city.humidity, uvIndex: city.uvIndex, feelsLike: city.feelsLike)
                        intermediate.append(cityWithID)
                    }
                }
                cityList = intermediate
            } catch {
                print("Error fetching results \(error)")
            }
        } else {
            print("Unable to use URL")
        }
    }
    
    
    func getWeather(with query: Int) async -> City? {
        let finishedURL = weatherURLBase + apiKey + "&q=id:" + String(query)
        if let url = URL(string: finishedURL) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                return parseCity(json: data)
            } catch {
                print("Error fetching results \(error)")
            }
        } else {
            print("Unable to use URL")
        }
        return nil
    }
    
    func restoreSavedCity() {
        isRestoring = true
        if let data = UserDefaults.standard.data(forKey: savedCityKey) {
            if let decoded = try? JSONDecoder().decode(CityWithID.self, from: data) {
                citySelected = decoded
                
           }
        }
        isRestoring = false
    }
    
    private func handleCitySelectionChange() {
        if isRestoring { return }
        if citySelected != nil {
            saveSelectedCity(city: citySelected!)
        }
    }
    
    func saveSelectedCity(city: CityWithID) {
        if let encoded = try? JSONEncoder().encode(city) {
            UserDefaults.standard.set(encoded, forKey: savedCityKey)
        }
        
    }
    
    func getWeatherOfSavedCity() async -> CityWithID? {
        if let citySelected {
            if let city = await getWeather(with: citySelected.id) {
                return CityWithID(name: city.name, region: citySelected.region, id: citySelected.id, temperature: city.temperature, condition: city.condition, humidity: city.humidity, uvIndex: city.uvIndex, feelsLike: city.feelsLike)
            }
        }
        return nil
    }
}
