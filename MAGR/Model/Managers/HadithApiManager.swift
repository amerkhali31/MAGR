//
//  HadithApiManager.swift
//  MAGR
//
//  Created by Amer Khalil on 12/15/24.
//

import Foundation

/**
 Fetches a hadith from hadith api
 - Returns: ``APIResponse``: the total response from hadith api
 - Note: Currently gets random hadith from Sahih Bukhari
 */
struct HadithApiManager {
    
    private static let baseUrl = "https://www.hadithapi.com/api/hadiths"
    private static let book = "sahih-bukhari"
    private static let hadithNumber = String(Int.random(in: 1...7563))
    private static let status = "Sahih"
    private static let apikey = PrivateKeys.hadithKey
    private static var urlString = ""
    
    static func fetchHadiths() async -> APIResponse? {
                
        urlString = "\(baseUrl)?apiKey=\(apikey)&book=\(book)&hadithNumber=\(hadithNumber)"
        guard let url = URL(string: urlString) else { print("Invalid URL") ; return nil}
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(APIResponse.self, from: data)

        } catch {print("Error: \(error)") ; return nil}
    }
}
