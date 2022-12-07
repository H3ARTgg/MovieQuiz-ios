import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func > (first: GameRecord, second: GameRecord) -> Bool {
        return first.correct > second.correct
    }
}
