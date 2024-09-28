//
//  KeyboardView.swift
//  APPIOApp
//
//  Created by Ваня Сокол on 21.09.2024.
//

import UIKit

final class KeyboardView: UIView {

    private var keyboardCollectionView: UICollectionView!
    var selectedKeys: [String] = []
    var completion: (([String]) -> Void)?
    
    var cellData = BaseCell.getKeyboardData() {
        didSet {
            keyboardCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupKeyboarCollectionView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupKeyboarCollectionView() {
        let layout = createKeyboardCollectionViewLayout()
        keyboardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        keyboardCollectionView.backgroundColor = .black
        keyboardCollectionView.delaysContentTouches = false
        keyboardCollectionView.delegate = self
        keyboardCollectionView.dataSource = self
        keyboardCollectionView.bounces = false
        keyboardCollectionView.showsVerticalScrollIndicator = false
        keyboardCollectionView.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.identifier)
        keyboardCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        addSubview(keyboardCollectionView)
        keyboardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            keyboardCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            keyboardCollectionView.topAnchor.constraint(equalTo: topAnchor),
            keyboardCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            keyboardCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setCellBaseState() {
        for (fristIndex, firstKey) in cellData.enumerated() {
            for (secondIndex, _) in firstKey.enumerated() {
                cellData[fristIndex][secondIndex].cellState = .base
                keyboardCollectionView.reloadData()
            }
        }
    }
    
    private func createKeyboardCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2.5, bottom: 0, trailing: 2.5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1 / 3))

            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 12),
                                                      heightDimension: .fractionalHeight(1))
                let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                layoutItem.contentInsets = contentInsets
                
                let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
                layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 8, bottom: 2.5, trailing: 8)
                
                let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
                return sectionLayout
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 11),
                                                      heightDimension: .fractionalHeight(1))
                let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                layoutItem.contentInsets = contentInsets
                
                let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
                layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 24, bottom: 2.5, trailing: 24)
                
                let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
                return sectionLayout

            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 9),
                                                      heightDimension: .fractionalHeight(1))
                let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                layoutItem.contentInsets = contentInsets
                
                let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
                layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 54, bottom: 2.5, trailing: 54)
                
                let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
                return sectionLayout
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 9),
                                                      heightDimension: .fractionalHeight(1))
                let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                layoutItem.contentInsets = contentInsets
                
                let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
                layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 54, bottom: 2.5, trailing: 54)
                
                let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
                return sectionLayout
            }
        }
    }
}

extension KeyboardView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.identifier, for: indexPath) as! BaseCollectionViewCell
        let cellData = cellData[indexPath.section][indexPath.row]
        cell.configure(with: cellData.key, keyState: cellData.cellState, keyFont: CellFont.keyboardFont)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setCellBaseState()
        
        let selectedKey = cellData[indexPath.section][indexPath.row].key
        
        if selectedKeys.count < 5 {
            selectedKeys.append(selectedKey)
            completion?(selectedKeys)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if selectedKeys.count < 5 {
            if let cell = collectionView.cellForItem(at: indexPath) as? BaseCollectionViewCell {
                cell.changeCellHighlight()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = nil
        }
    }
}
