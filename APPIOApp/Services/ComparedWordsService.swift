//
//  ComparedWordsService.swift
//  APPIOApp
//
//  Created by Ваня Сокол on 22.09.2024.
//

import Foundation

final class ComparedWordsService {
    
    private let decoder = JSONDecoder()
    private var fileName = "words"
    var comparedWords: Words!

    public init() {
        loadComparedWords()
    }

    private func loadComparedWords() {
        let bundle = Bundle.main
        let url = bundle.url(forResource: fileName, withExtension: "json")!
        
        do {
            let data = try Data(contentsOf: url)
            self.comparedWords = try decoder.decode(Words.self, from: data)
        } catch (let error) {
            print("Retrieve failed: URL: '\(url)', Error: '\(error)'")
        }
    }
}
