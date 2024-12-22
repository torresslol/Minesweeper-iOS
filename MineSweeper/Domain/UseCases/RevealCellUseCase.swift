//
//  RevealCellUseCase.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

/// 揭示格子的用例
/// 处理游戏核心逻辑，包括首次点击、地雷判定、连锁揭示
protocol RevealCellUseCase {
    /// 执行揭示格子操作
    func execute(at row: Int, column: Int) -> (
        state: CellState?,
        gameState: GameState,
        remainingCells: Int
    )
}

class RevealCellUseCaseImpl: RevealCellUseCase {
    private let gameRepository: GameRepository
    private var board: Board
    private var gameState: GameState = .ready
    private var revealedCount: Int = 0
    private var remainingNonMineCells: Int
    private let logger: Logger
    
    init(
        gameRepository: GameRepository,
        board: Board,
        logger: Logger = AppContext.shared.logger
    ) {
        self.gameRepository = gameRepository
        self.board = board
        self.logger = logger
        self.remainingNonMineCells = (
            board.rows * board.columns
        ) - board.mineCount
    }
    
    func execute(at row: Int, column: Int) -> (
        state: CellState?,
        gameState: GameState,
        remainingCells: Int
    ) {
        logger.debug("Revealing cell at row: \(row), column: \(column)")
        guard isValidPosition(row: row, column: column) else {
            return (nil, gameState, remainingNonMineCells)
        }
        guard !board
            .isRevealed(at: row, column: column) else {
            return (nil, gameState, remainingNonMineCells)
        }
        guard gameState != .lost && gameState != .won else {
            return (nil, gameState, remainingNonMineCells)
        }
        
        if gameState == .ready {
            placeMinesExcluding(row: row, column: column)
            gameState = .playing
        }
        
        if board.isMine(at: row, column: column) {
            board.setRevealed(at: row, column: column, value: true)
            gameState = .lost
            revealAllMines()
            return (.mine, gameState, 0)
        }
        
        revealEmptyCells(row: row, column: column)
        
        remainingNonMineCells = calculateRemainingNonMineCells()
        
        if checkWinCondition() {
            return (
                .revealed(
                    neighborCount: board
                        .getNeighborCount(at: row, column: column)
                ),
                gameState,
                remainingNonMineCells
            )
        }
        
        gameRepository.saveGameState(board)
        
        return (
            .revealed(
                neighborCount: board.getNeighborCount(at: row, column: column)
            ),
            gameState,
            remainingNonMineCells
        )
    }
    
    private func calculateRemainingNonMineCells() -> Int {
        let totalNonMineCells = (board.rows * board.columns) - board.mineCount
        return totalNonMineCells - revealedCount
    }
    
    private func isValidPosition(row: Int, column: Int) -> Bool {
        return row >= 0 && row < board.rows && column >= 0 && column < board.columns
    }
    
    /// 递归揭示空格子
    /// 当点击到空格子（周围没有地雷）时，自动揭示周围的格子
    /// 遍历所有相连的空格子
    private func revealEmptyCells(row: Int, column: Int) {
        if !board.isRevealed(at: row, column: column) {
            board.setRevealed(at: row, column: column, value: true)
            revealedCount += 1
            
            if board.getNeighborCount(at: row, column: column) == 0 {
                board.forEachNeighbor(of: (row, column)) { r, c in
                    revealEmptyCells(row: r, column: c)
                }
            }
        }
    }
    
    /// 确保首次点击安全
    /// 1. 确保首次点击的格子及其周围没有地雷
    /// 2. 随机分布地雷到其他位置
    /// 3. 计算所有格子周围的地雷数
    /// 4. 确保游戏体验，第一次会揭开附近的空格子
    private func placeMinesExcluding(row: Int, column: Int) {
        var minesPlaced = 0
        while minesPlaced < board.mineCount {
            let r = Int.random(in: 0..<board.rows)
            let c = Int.random(in: 0..<board.columns)
            
            if (r != row || c != column) && !board.isMine(at: r, column: c) {
                board.setMine(at: r, column: c, value: true)
                minesPlaced += 1
            }
        }
        
        for r in 0..<board.rows {
            for c in 0..<board.columns {
                if !board.isMine(at: r, column: c) {
                    board
                        .setNeighborCount(
                            at: r,
                            column: c,
                            value: countAdjacentMines(row: r, column: c)
                        )
                }
            }
        }
        
        revealInitialCells(around: row, column: column)
        
        board.clearCache()
    }
    
    private func countAdjacentMines(row: Int, column: Int) -> Int {
        return board.getNeighborMineCount(at: row, column: column)
    }
    
    private func revealInitialCells(around row: Int, column: Int) {
        for i in -1...1 {
            for j in -1...1 {
                let newRow = row + i
                let newCol = column + j
                if isValidPosition(row: newRow, column: newCol) && !board
                    .isMine(at: newRow, column: newCol) {
                    revealEmptyCells(row: newRow, column: newCol)
                }
            }
        }
    }
    
    private func checkWinCondition() -> Bool {
        let totalNonMineCells = (board.rows * board.columns) - board.mineCount
        if revealedCount == totalNonMineCells {
            gameState = .won
            return true
        }
        return false
    }
    
    private func revealAllMines() {
        for row in 0..<board.rows {
            for col in 0..<board.columns {
                if board.isMine(at: row, column: col) {
                    board.setRevealed(at: row, column: col, value: true)
                }
            }
        }
    }
} 
