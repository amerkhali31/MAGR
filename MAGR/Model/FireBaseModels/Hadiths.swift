//
//  Hadiths.swift
//  MAGR
//
//  Created by Amer Khalil on 12/15/24.
//

import Foundation

struct APIResponse: Codable {
    let status: Int
    let hadiths: [Hadiths]
}

struct Hadiths: Codable {
    let data: [Hadith]
}

struct Hadith: Codable {
    let hadithNumber: Int
    let englishNarrator: String
    let hadithEnglish: String
    let bookSlug: String
    let volume: String
    let status: String
    let chapter: Chapter
}

struct Chapter: Codable {
    let chapterEnglish: String
}
