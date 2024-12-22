//
//  GameBoardCell.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import UIKit
import SnapKit

class GameBoardCell: UICollectionViewCell {
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        countLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    func configure(viewModel: CellModel) {
        switch viewModel.state {
        case .covered:
            contentView.backgroundColor = .covered
            countLabel.text = nil
        case .mine:
            contentView.backgroundColor = .revealed
            countLabel.font = .mine
            countLabel.text = "💣"
        case .revealed(let neighborCount):
            contentView.backgroundColor = .revealed
            if neighborCount > 0 {
                countLabel.font = .revealed
                countLabel.text = "\(neighborCount)"
                countLabel.textColor = UIColor.colorForMineCount(neighborCount)
            } else {
                countLabel.text = nil
            }
        }
    }
    
    func startBreathingAnimation() {
        contentView.layer.removeAllAnimations()
            
        let originalColor = contentView.backgroundColor
        let highlightColor = UIColor.hint
        contentView.transform = CGAffineTransform.identity
            
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.repeat, .autoreverse, .allowUserInteraction],
                       animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.contentView.backgroundColor = highlightColor
        }, completion: { _ in
            self.contentView.backgroundColor = originalColor
        })
    }

    func stopBreathingAnimation() {
        contentView.layer.removeAllAnimations()
        self.contentView.transform = CGAffineTransform.identity
        self.contentView.backgroundColor = .covered
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countLabel.text = nil
        contentView.backgroundColor = .covered
    }
    
}

