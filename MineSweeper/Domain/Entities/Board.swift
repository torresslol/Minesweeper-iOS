/// 游戏板
class Board {

    private var cells: [BoardCell]
    let rows: Int
    let columns: Int
    let mineCount: Int
    
    init(rows: Int, columns: Int, mineCount: Int) {
        self.rows = rows
        self.columns = columns
        self.mineCount = mineCount
        self.cells = Array(repeating: BoardCell(), count: rows * columns)
    }
    
    subscript(row: Int, column: Int) -> BoardCell {
        get {
            cells[row * columns + column]
        }
        set {
            cells[row * columns + column] = newValue
        }
    }
    
    func isMine(at row: Int, column: Int) -> Bool {
        self[row, column].isMine
    }
    
    func isRevealed(at row: Int, column: Int) -> Bool {
        self[row, column].isRevealed
    }
    
    func setMine(at row: Int, column: Int, value: Bool) {
        self[row, column].isMine = value
    }
    
    func setRevealed(at row: Int, column: Int, value: Bool) {
        self[row, column].isRevealed = value
    }
    
    func getNeighborCount(at row: Int, column: Int) -> Int {
        self[row, column].neighborMineCount
    }
    
    func setNeighborCount(at row: Int, column: Int, value: Int) {
        self[row, column].neighborMineCount = value
    }
    
    /// 检查位置是否有效
    /// - Parameters:
    ///   - row: 行索引
    ///   - column: 列索引
    /// - Returns: 如果位置在游戏板范围内返回 true
    private func isValidPosition(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    // 提供邻居遍历方法，避免重复的边界检查
    func forEachNeighbor(of position: (row: Int, column: Int), 
                         action: (Int, Int) -> Void) {
        for i in -1...1 {
            for j in -1...1 {
                let newRow = position.row + i
                let newCol = position.column + j
                if isValidPosition(row: newRow, column: newCol) {
                    action(newRow, newCol)
                }
            }
        }
    }
    
    //  缓存常用计算结果
    private var neighborCache: [Int: Int]?
    
    func getNeighborMineCount(at row: Int, column: Int) -> Int {
        let index = row * columns + column
        if let cached = neighborCache?[index] {
            return cached
        }
        
        var count = 0
        forEachNeighbor(of: (row, column)) { r, c in
            if self[r, c].isMine {
                count += 1
            }
        }
        
        // 初始化缓存（如果需要）
        if neighborCache == nil {
            neighborCache = [:]
        }
        neighborCache?[index] = count
        return count
    }
    
    // 提供批量操作方法
    func revealArea(
        from: (row: Int, column: Int),
        to: (row: Int, column: Int)
    ) {
        for row in from.row...to.row {
            let startIndex = row * columns + from.column
            let endIndex = row * columns + to.column
            cells[startIndex...endIndex].indices.forEach { index in
                cells[index].isRevealed = true
            }
        }
    }
    
    // 提供清除缓存的方法
    func clearCache() {
        neighborCache = nil
    }
} 
