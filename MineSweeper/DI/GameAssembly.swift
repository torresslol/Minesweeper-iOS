class GameAssembly {
    static func assembleGameViewController(difficulty: GameDifficulty) -> GameViewController {
        let logger = AppContext.shared.logger ?? TempLogger()
        let gameRepository = GameRepositoryImpl()
        let board = Board(rows: difficulty.configuration.rows,
                          columns: difficulty.configuration.columns,
                          mineCount: difficulty.configuration.mines)
        
        let revealCellUseCase = RevealCellUseCaseImpl(gameRepository: gameRepository,
                                                      board: board,
                                                      logger: logger)
        let getHintUseCase = GetHintUseCaseImpl(board: board,
                                                logger: logger)
        let getBoardStateUseCase = GetBoardStateUseCaseImpl(board: board,
                                                            logger: logger)
        
        let viewModel = GameViewModel(revealCellUseCase: revealCellUseCase,
                                      getHintUseCase: getHintUseCase,
                                      getBoardStateUseCase: getBoardStateUseCase,
                                      gameRepository: gameRepository,
                                      difficulty: difficulty,
                                      logger: logger)
        
        return GameViewController(viewModel: viewModel, logger: logger)
    }
} 
