//
//  GetBoardStateUseCase.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

protocol GetBoardStateUseCase {
    func execute() -> [CellState]
}

class GetBoardStateUseCaseImpl: GetBoardStateUseCase {
    private let board: Board
    private let logger: Logger
    
    init(board: Board, logger: Logger = AppContext.shared.logger!) {
        self.board = board
        self.logger = logger
    }
    
    func execute() -> [CellState] {
        logger.debug("Getting board state...")
        var result: [CellState] = []
        for row in 0..<board.rows {
            for col in 0..<board.columns {
                let cell = board[row, col]
                if !cell.isRevealed {
                    result.append(.covered)
                } else if cell.isMine {
                    result.append(.mine)
                } else {
                    result.append(.revealed(neighborCount: cell.neighborMineCount))
                }
            }
        }
        return result
    }
}
