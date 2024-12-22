//
//  GameCollectionViewLayout.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import UIKit

class GameCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
