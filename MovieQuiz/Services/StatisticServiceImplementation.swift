import Foundation

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, array
    }
    
    private let userDefaults = UserDefaults.standard
    private(set) var accuracyArray: [Double] {
        get {
            let result = userDefaults.object(forKey: Keys.array.rawValue) as? [Double] ?? []
            return result
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.array.rawValue)
        }
    }
    
    private(set) var totalAccuracy: Double {
        get {
            let result = userDefaults.double(forKey: Keys.total.rawValue)
            return result
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    private(set) var gamesCount: Int {
        get {
            let result = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return result
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        
        let accuracy = (Double(count) / Double(amount)) * 100.0
        
        var newAccuracyArray = accuracyArray
        newAccuracyArray.append(accuracy)
        accuracyArray = newAccuracyArray
        
        totalAccuracy = accuracyArray.reduce(0, +) / Double(gamesCount)
        
        let game = GameRecord(correct: count, total: amount, date: Date())
        if game > bestGame {
            bestGame = game
        }
    }
}
