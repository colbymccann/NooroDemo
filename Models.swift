//
//  City.swift
//  NooroDemo
//
//  Created by Colby McCann on 1/17/25.
//

import Foundation

protocol SearchProtocol: Identifiable, Codable, Equatable {
}

struct SearchResult: SearchProtocol {
    let name: String
    let region: String
    let country: String
    let id: Int
    let lat: Double
    let lon: Double
    let url: String
    
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }
}

struct Condition: Codable {
    var text: String
    var icon: String
    var code: Int
}

struct City: Codable {
    var name: String
    var temperature: Double
    var condition: Condition
    var humidity: Int
    var uvIndex: Double
    var feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case location
        case current
    }

    enum LocationKeys: String, CodingKey {
        case name
    }

    enum CurrentKeys: String, CodingKey {
        case temp_c
        case condition
        case humidity
        case uv
        case feelslike_c
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let locationContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        name = try locationContainer.decode(String.self, forKey: .name)

        let currentContainer = try container.nestedContainer(keyedBy: CurrentKeys.self, forKey: .current)
        temperature = try currentContainer.decode(Double.self, forKey: .temp_c)
        condition = try currentContainer.decode(Condition.self, forKey: .condition)
        humidity = try currentContainer.decode(Int.self, forKey: .humidity)
        uvIndex = try currentContainer.decodeIfPresent(Double.self, forKey: .uv) ?? 0.0
        feelsLike = try currentContainer.decode(Double.self, forKey: .feelslike_c)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        var locationContainer = container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        try locationContainer.encode(name, forKey: .name)

        var currentContainer = container.nestedContainer(keyedBy: CurrentKeys.self, forKey: .current)
        try currentContainer.encode(temperature, forKey: .temp_c)
        try currentContainer.encode(condition, forKey: .condition)
        try currentContainer.encode(humidity, forKey: .humidity)
        try currentContainer.encode(uvIndex, forKey: .uv)
        try currentContainer.encode(feelsLike, forKey: .feelslike_c)
    }
}

struct CityWithID: SearchProtocol {
    let name: String
    let region: String
    let id: Int
    let temperature: Double
    let condition: Condition
    let humidity: Int
    let uvIndex: Double
    let feelsLike: Double
    
    static func == (lhs: CityWithID, rhs: CityWithID) -> Bool {
        lhs.id == rhs.id
    }
    
    static var example: CityWithID {
        return CityWithID(name: "Boston", region: "MA", id: 12345, temperature: 22.4, condition: Condition(text: "Sunny", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png", code: 113), humidity: 60, uvIndex: 6.0, feelsLike: 22.4)
    }
}
