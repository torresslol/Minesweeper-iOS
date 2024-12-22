//
//  GameViewModel.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import Foundation
import Combine

class GameViewModel {
    private var revealCellUseCase: RevealCellUseCase
    private var getHintUseCase: GetHintUseCase
    private var getBoardStateUseCase: GetBoardStateUseCase
    private var gameRepository: GameRepository
    private let logger: Logger
    
    @Published private(set) var gameState: GameState = .ready
    @Published private(set) var remainingNonMineCells: Int
    @Published private(set) var boardState: [CellState] = []
    let difficulty: GameDifficulty
    
    init(revealCellUseCase: RevealCellUseCase,
         getHintUseCase: GetHintUseCase,
         getBoardStateUseCase: GetBoardStateUseCase,
         gameRepository: GameRepository,
         difficulty: GameDifficulty,
         logger: Logger = AppContext.shared.logger) {
        self.logger = logger
        self.revealCellUseCase = revealCellUseCase
        self.getHintUseCase = getHintUseCase
        self.getBoardStateUseCase = getBoardStateUseCase
        self.gameRepository = gameRepository
        self.difficulty = difficulty
        let config = difficulty.configuration
        self.remainingNonMineCells = (
            config.rows * config.columns
        ) - config.mines
    }
    
    func revealCell(at row: Int, column: Int) {
        logger.info("User tapped cell at (\(row), \(column))")
        let result = revealCellUseCase.execute(at: row, column: column)
        if let _ = result.state {
            gameState = result.gameState
            remainingNonMineCells = result.remainingCells
            boardState = getBoardStateUseCase.execute()
        }
    }
    
    func getHint() -> (row: Int, column: Int)? {
        return getHintUseCase.execute()
    }
    
    func getBoardState() -> [CellState] {
        return getBoardStateUseCase.execute()
    }
    
    func resetGame() {
        logger.info("Resetting game...")
        // 重新创建所有依赖
        let gameRepository = GameRepositoryImpl()
        let board = Board(rows: difficulty.configuration.rows,
                          columns: difficulty.configuration.columns,
                          mineCount: difficulty.configuration.mines)
        
        let revealCellUseCase = RevealCellUseCaseImpl(gameRepository: gameRepository,
                                                      board: board)
        let getHintUseCase = GetHintUseCaseImpl(board: board)
        let getBoardStateUseCase = GetBoardStateUseCaseImpl(board: board)
        
        // 重置状态
        gameState = .ready
        remainingNonMineCells = (
            difficulty.configuration.rows * difficulty.configuration.columns
        ) - difficulty.configuration.mines
        boardState = getBoardStateUseCase.execute()
        
        // 更新 use cases
        self.revealCellUseCase = revealCellUseCase
        self.getHintUseCase = getHintUseCase
        self.getBoardStateUseCase = getBoardStateUseCase
        self.gameRepository = gameRepository
    }
} 
