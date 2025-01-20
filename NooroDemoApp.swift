//
//  NooroDemoApp.swift
//  NooroDemo
//
//  Created by Colby McCann on 1/17/25.
//

import SwiftUI

@main
struct NooroDemoApp: App {
    @StateObject var viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
    }
}
