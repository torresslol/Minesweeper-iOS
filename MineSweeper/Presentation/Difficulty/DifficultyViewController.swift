//
//  DifficultyViewController.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import UIKit
import SnapKit

class DifficultyViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MineSweeper"
        label.font = .title
        label.textColor = .title
        label.textAlignment = .center
        view.addSubview(label)
        return label
    }()
    
    private lazy var beginnerButton: MainButton = {
        let button = MainButton()
        button.setTitle("Beginner", for: .normal)
        button.layer.cornerRadius = 12
        button
            .addTarget(
                self,
                action: #selector(beginnerTapped),
                for: .touchUpInside
            )
        view.addSubview(button)
        return button
    }()
    
    private lazy var intermediateButton: MainButton = {
        let button = MainButton()
        button.setTitle("Intermediate", for: .normal)
        button.layer.cornerRadius = 12
        button
            .addTarget(
                self,
                action: #selector(intermediateTapped),
                for: .touchUpInside
            )
        view.addSubview(button)
        return button
    }()
    
    private lazy var expertButton: MainButton = {
        let button = MainButton()
        button.setTitle("Expert", for: .normal)
        button.layer.cornerRadius = 12
        button
            .addTarget(
                self,
                action: #selector(expertTapped),
                for: .touchUpInside
            )
        view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        beginnerButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-90)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        intermediateButton.snp.makeConstraints {
            $0.top.equalTo(beginnerButton.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        expertButton.snp.makeConstraints {
            $0.top.equalTo(intermediateButton.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func beginnerTapped() {
        startGame(with: .beginner)
    }
    
    @objc private func intermediateTapped() {
        startGame(with: .intermediate)
    }
    
    @objc private func expertTapped() {
        startGame(with: .expert)
    }
    
    private func startGame(with difficulty: GameDifficulty) {
        let gameVC = GameAssembly.assembleGameViewController(
            difficulty: difficulty
        )
        navigationController?.pushViewController(gameVC, animated: true)
    }
} 
