//
//  SubscriptionDataStore.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import Foundation

final class SubscriptionDataStore {
    
    func loadJSON() throws -> Data {
        let fileURL = try subscriptionsFileURL()
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return try Data(contentsOf: fileURL)
        } else {
            guard let bundleURL = Bundle.main.url(forResource: "subscriptions", withExtension: "json") else {
                throw NSError(domain: "FileNotFoundInBundle", code: 404, userInfo: nil)
            }
            let data = try Data(contentsOf: bundleURL)
            try data.write(to: fileURL, options: .atomic)
            return data
        }
    }
    
    func saveJSON(_ subscriptions: [Subscription]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(subscriptions)
        let fileURL = try subscriptionsFileURL()
        try data.write(to: fileURL, options: .atomic)
    }
    
    private func subscriptionsFileURL() throws -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else {
            throw NSError(domain: "FileNotFound", code: 404, userInfo: nil)
        }
        return documentsURL.appendingPathComponent("subscriptions.json")
    }
    
    func clearDocumentsFile() {
        do {
            let fileURL = try subscriptionsFileURL()
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
                print("Usunięto plik w Documents, przy następnym odczycie skopiuje z bundle")
            }
        } catch {
            print("Błąd usuwania pliku: \(error)")
        }
    }
}
