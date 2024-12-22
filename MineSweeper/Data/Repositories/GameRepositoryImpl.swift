import Foundation

class GameRepositoryImpl: GameRepository {
    private let defaults = UserDefaults.standard
    private let gameStateKey = "gameState"
    
    func saveGameState(_ board: Board) {
    }
    
    func loadGameState() -> Board? {
        return nil
    }
    
    func clearGameState() {
        defaults.removeObject(forKey: gameStateKey)
    }
} 
