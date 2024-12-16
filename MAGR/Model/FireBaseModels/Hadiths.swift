//
//  Hadiths.swift
//  MAGR
//
//  Created by Amer Khalil on 12/15/24.
//

import Foundation

/**
 The return type of hadith api
 - Parameters:
    - status: The code returning the result type of the interaction
    - hadiths: Contain Hadiths object with data parameter
    - data: Contains a list of Hadith objects. In the current use case, only one Hadith will be in the list
    - Hadith: Contains hadithNumber, englishNarrator, hadithEnglish, bookSlug, vilume, status, and chapter
    - hadithNumber: The number identifier of the hadtih
    - englishNarrator: The narrator of the hadith, written in english
    - hadithEnglish: The hadith written in english
    - bookSlug: The name of the book the hadith is gotten from
    - volume: The volume of the book the hadith is gotten from
    - status: Whether the hadith is Sahih or not
    - chapter: The chapter of the volume of the book that the hadith is from
 
 */
struct APIResponse: Codable {
    let status: Int?
    let hadiths: Hadiths?
}

struct Hadiths: Codable {
    let data: [Hadith?]?
}

struct Hadith: Codable {
    let hadithNumber: String?
    let englishNarrator: String?
    let hadithEnglish: String?
    let bookSlug: String?
    let volume: String?
    let status: String?
    let chapter: Chapter?
}

struct Chapter: Codable {
    let chapterEnglish: String?
}
