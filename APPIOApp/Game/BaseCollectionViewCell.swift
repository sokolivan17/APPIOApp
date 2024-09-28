//
//  BaseCollectionViewCell.swift
//  APPIOApp
//
//  Created by Ваня Сокол on 21.09.2024.
//

import UIKit

final class BaseCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BaseCell"
    
    private let keyLabel = UILabel()
    private let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 4
        
        keyLabel.textColor = .white
    }
    
    private func setupLayout() {
       addSubview(containerView)
       addSubview(keyLabel)
       
        containerView.translatesAutoresizingMaskIntoConstraints = false
        keyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            keyLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            keyLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    public func changeCellHighlight() {
        containerView.backgroundColor = .white.withAlphaComponent(0.5)
    }
    
    public func configure(with keyString: String, keyState: BaseCellState = .base, keyFont: UIFont) {
        keyLabel.text = keyString
        keyLabel.font = keyFont
        
        switch keyState {
        case .base:
            containerView.layer.borderColor = UIColor.white.cgColor
            containerView.layer.borderWidth = 1
            containerView.backgroundColor = .black
            keyLabel.textColor = .white
        case .correct:
            containerView.layer.borderColor = UIColor.green.cgColor
            containerView.layer.borderWidth = 0
            containerView.backgroundColor = .green
            keyLabel.textColor = .black
        case .wrongPlace:
            containerView.layer.borderColor = UIColor.white.cgColor
            containerView.backgroundColor = .white
            containerView.layer.borderWidth = 0
            keyLabel.textColor = .black
        case .noMatch:
            containerView.layer.borderColor = UIColor.gray.cgColor
            containerView.backgroundColor = .gray
            containerView.layer.borderWidth = 0
            keyLabel.textColor = .white
        }
    }
}

enum CellFont {
    static let keyboardFont: UIFont = .systemFont(ofSize: 18, weight: .medium)
    static let gridFont: UIFont = .systemFont(ofSize: 36, weight: .regular)
}
