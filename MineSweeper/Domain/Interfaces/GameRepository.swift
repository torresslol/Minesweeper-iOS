protocol GameRepository {
    func saveGameState(_ board: Board)
    func loadGameState() -> Board?
    func clearGameState()
} 