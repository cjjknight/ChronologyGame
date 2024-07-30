import Foundation

struct ChronologyEvent: Identifiable {
    var id = UUID()
    var description: String
    var year: Int
}

let initialEvents: [ChronologyEvent] = [
    ChronologyEvent(description: "First Moon Landing", year: 1969),
    ChronologyEvent(description: "Declaration of Independence", year: 1776),
    ChronologyEvent(description: "Fall of the Berlin Wall", year: 1989),
    ChronologyEvent(description: "Invention of the Telephone", year: 1876),
    ChronologyEvent(description: "World War II Ends", year: 1945),
    ChronologyEvent(description: "Gutenberg Printing Press", year: 1440),
    ChronologyEvent(description: "Discovery of Penicillin", year: 1928),
    ChronologyEvent(description: "American Civil War Begins", year: 1861),
    ChronologyEvent(description: "French Revolution Begins", year: 1789),
    ChronologyEvent(description: "Women's Suffrage in USA", year: 1920),
    ChronologyEvent(description: "Man Walks on the Moon", year: 1969),
    ChronologyEvent(description: "First Powered Flight", year: 1903),
    ChronologyEvent(description: "Internet Invented", year: 1983),
    ChronologyEvent(description: "Fall of Constantinople", year: 1453),
    ChronologyEvent(description: "Magna Carta Signed", year: 1215),
    ChronologyEvent(description: "Discovery of DNA Structure", year: 1953),
    ChronologyEvent(description: "First Nuclear Bomb Detonated", year: 1945),
    ChronologyEvent(description: "Columbus Reaches America", year: 1492),
    ChronologyEvent(description: "Protestant Reformation Begins", year: 1517),
    ChronologyEvent(description: "Assassination of Archduke Ferdinand", year: 1914),
    ChronologyEvent(description: "Signing of the Treaty of Versailles", year: 1919),
    ChronologyEvent(description: "First Crusade Launched", year: 1096),
    ChronologyEvent(description: "Russian Revolution", year: 1917),
    ChronologyEvent(description: "First Satellite in Space (Sputnik)", year: 1957),
    ChronologyEvent(description: "Martin Luther King Jr.'s 'I Have a Dream' Speech", year: 1963)
]
