//
//  CellState.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import Foundation

// MARK: - 方格状态
/// mine: 地雷, covered: 未揭示, discovered: 揭示（附近地雷数）
enum CellState {
    case mine
    case covered
    case revealed(neighborCount: Int)
}

extension CellState: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .mine: hasher.combine(1000)   // 地雷
        case .covered: hasher.combine(10001)    // 未揭示
        case .revealed(let count): hasher.combine(count)    // 揭示（附近地雷数）
        }
    }
}

// MARK: - 实现 Equatable 协议
extension CellState: Equatable {
    static func == (lhs: CellState, rhs: CellState) -> Bool {
        switch (lhs, rhs) {
        case (.mine, .mine): return true    // 地雷
        case (.covered, .covered): return true    // 未揭示
        case (.revealed(let a), .revealed(let b)): return a == b    // 揭示（附近地雷数）
        default: return false
        }
    }
}
