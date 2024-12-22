import UIKit
import IGListKit
import SnapKit
import Combine

class GameViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: GameViewModel
    private let logger: Logger
    private var cancellables: Set<AnyCancellable> = []
    
    var cellModels: [CellModel] = [] {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }
    
    var highlightedCell: GameBoardCell?
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self)
        adapter.dataSource = self
        adapter.collectionView = collectionView
        return adapter
    }()
    
    private let cellSpacing: CGFloat = 1
    private let boardPadding: CGFloat = 16
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        view.addSubview(label)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = GameCollectionViewLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.register(GameBoardCell.self, forCellWithReuseIdentifier: String(describing: GameBoardCell.self))
        view.addSubview(cv)
        return cv
    }()
    
    lazy var hintButton: MainButton = {
        let hint = MainButton(frame: .zero)
        hint.setTitle("Hint", for: .normal)
        view.addSubview(hint)
        return hint
    }()
    
    lazy var retryButton: MainButton = {
        let retry = MainButton(frame: .zero)
        retry.setTitle("Play Again", for: .normal)
        retry.alpha = 0 // Initialize with alpha 0 for fade-in effect
        retry.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) // Initialize with scale for zoom-in effect
        view.addSubview(retry)
        return retry
    }()
    
    // MARK: - Initializer
    
    init(viewModel: GameViewModel, logger: Logger = AppContext.shared.logger) {
        self.viewModel = viewModel
        self.logger = logger
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupUI()
    }
    
    // MARK: - Setup Methods
    
    private func setupBindings() {
        viewModel.$gameState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.handleGameStateChange(state)
            }
            .store(in: &cancellables)
        
        viewModel.$remainingNonMineCells
            .receive(on: RunLoop.main)
            .sink { [weak self] count in
                self?.updateRemainingCellsLabel(count)
            }
            .store(in: &cancellables)
        
        viewModel.$boardState
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] boardState in
                guard let self = self else { return }
                self.cellModels = boardState.enumerated().map { (index, state) in
                    let rowIndex = index / self.viewModel.difficulty.configuration.columns
                    let columnIndex = index % self.viewModel.difficulty.configuration.columns
                    return CellModel(state: state, row: rowIndex, column: columnIndex)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupTitle()
        setupCollectionView()
        setupHint()
        setupRetry()
        loadInitialBoard()
    }
    
    private func setupTitle() {
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        titleLabel.font = .title
        titleLabel.text = ""
    }
    
    private func setupHint() {
        hintButton.backgroundColor = .hint
        hintButton.layer.cornerRadius = 12
        hintButton.addTarget(self, action: #selector(triggerHintAnimation), for: .touchUpInside)
        hintButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    private func setupRetry() {
        retryButton.backgroundColor = .hint
        retryButton.layer.cornerRadius = 12
        retryButton.addTarget(self, action: #selector(triggerRetry), for: .touchUpInside)
        retryButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalTo(hintButton.snp.top).offset(-12)
        }
    }
    
    private func setupCollectionView() {
        let config = viewModel.difficulty.configuration
        let availableWidth = view.bounds.width - (boardPadding * 2)
        let totalWidth = availableWidth
        let totalHeight = (totalWidth / CGFloat(config.columns)) * CGFloat(config.rows)
        
        collectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(totalWidth)
            make.height.equalTo(totalHeight)
        }
    }
    
    // MARK: - Action Methods
    
    @objc func triggerHintAnimation() {
        // 如果当前有提示显示，则不执行任何操作
        if highlightedCell != nil {
            return
        }
        
        if let position = viewModel.getHint() {
            let indexPath = IndexPath(item: position.column, section: position.row)
            if let cell = collectionView.cellForItem(at: indexPath) as? GameBoardCell {
                cell.startBreathingAnimation()
                highlightedCell = cell
            }
        }
    }
    
    @objc func triggerRetry() {
        switch viewModel.gameState {
        case .won, .lost:
            reset()
        default:
            break
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleGameStateChange(_ gameState: GameState) {
        // 根据游戏状态更新UI，例如显示胜利或失败的提示
        switch gameState {
        case .won:
            titleLabel.textColor = .title
            titleLabel.text = "Congratulations! You Win!"
            hintButton.isEnabled = false
            showRetryButton()
        case .lost:
            titleLabel.text = "Game Over!"
            titleLabel.textColor = .mine
            hintButton.isEnabled = false
            showRetryButton()
        case .ready:
            titleLabel.textColor = .title
            titleLabel.text = "Let's Go!"
            hintButton.isEnabled = false
            retryButton.isHidden = true
        case .playing:
            hintButton.isEnabled = true
            retryButton.isHidden = true
        }
    }
    
    private func updateRemainingCellsLabel(_ remainingCells: Int) {
        // 更新屏幕上的剩余非雷格子数提示，仅当游戏状态为 playing 时
        if viewModel.gameState == .playing {
            titleLabel.text = "Remaining non-mine cells: \(remainingCells) !"
        }
    }
    
    private func reset() {
        viewModel.resetGame()
        loadInitialBoard()
        titleLabel.text = "Let's Go!"
        titleLabel.textColor = .title
        hintButton.isEnabled = false
        retryButton.isHidden = true
    }
    
    private func showRetryButton() {
        retryButton.isHidden = false
        retryButton.alpha = 0
        retryButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.retryButton.alpha = 1
            self.retryButton.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    private func loadInitialBoard() {
        let config = viewModel.difficulty.configuration
        logger.debug("Initializing board with config - Rows: \(config.rows), Columns: \(config.columns)")
        
        let boardState = viewModel.getBoardState()
        cellModels = boardState.enumerated().map { (index, state) in
            let rowIndex = index / viewModel.difficulty.configuration.columns
            let columnIndex = index % viewModel.difficulty.configuration.columns
            return CellModel(state: state, row: rowIndex, column: columnIndex)
        }
        
        logger.debug("Total cell models initialized: \(cellModels.count)")
    }

    func handleCellSelected(at row: Int, column: Int) {
        // 如果当前有hint的cell，取消这个hint
        if let highlightedCell = highlightedCell {
            highlightedCell.stopBreathingAnimation()
            self.highlightedCell = nil
        }
        
        viewModel.revealCell(at: row, column: column)
    }
}

// MARK: - ListAdapterDataSource

extension GameViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let config = viewModel.difficulty.configuration
        var sections: [[CellModel]] = []
        
        guard cellModels.count == config.rows * config.columns else {
            logger.error("Cell models count mismatch - Expected: \(config.rows * config.columns), Actual: \(cellModels.count)")
            return []
        }
        
        for row in 0..<config.rows {
            let startIndex = row * config.columns
            let endIndex = startIndex + config.columns
            let rowModels = Array(cellModels[startIndex..<endIndex])
            sections.append(rowModels)
        }
        
        return sections.enumerated().map { index, row in
            SectionModel(row: index, cells: row)
        }
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = GameSectionController()
        sectionController.gameViewController = self
        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // 为 SectionController 提供必要的配置信息
    func getGameConfiguration() -> GameConfiguration {
        return viewModel.difficulty.configuration
    }
}
