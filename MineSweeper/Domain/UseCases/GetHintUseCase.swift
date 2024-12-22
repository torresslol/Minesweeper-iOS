//
//  GetHintUseCase.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

protocol GetHintUseCase {
    func execute() -> (row: Int, column: Int)?
}

class GetHintUseCaseImpl: GetHintUseCase {
    private let board: Board
    private let logger: Logger
    
    init(board: Board, logger: Logger = AppContext.shared.logger!) {
        self.board = board
        self.logger = logger
    }
    
    func execute() -> (row: Int, column: Int)? {
        logger.debug("Searching for hint...")
        for r in 0..<board.rows {
            for c in 0..<board.columns {
                if !board[r, c].isRevealed && !board[r, c].isMine {
                    logger.debug("Found hint at (\(r), \(c))")
                    return (r, c)
                }
            }
        }
        logger.warning("No hint available")
        return nil
    }
} 
