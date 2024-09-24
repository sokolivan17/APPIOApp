//
//  GridView.swift
//  APPIOApp
//
//  Created by Ваня Сокол on 21.09.2024.
//

import UIKit

final class GridView: UIView {
    
    private var gridCollectionView: UICollectionView!
    var gridData = BaseCell.getGridData() {
        didSet {
            gridCollectionView.reloadData()
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
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gridCollectionView.backgroundColor = .black
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        gridCollectionView.bounces = false
        gridCollectionView.showsVerticalScrollIndicator = false
        gridCollectionView.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.identifier)
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        addSubview(gridCollectionView)
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gridCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridCollectionView.topAnchor.constraint(equalTo: topAnchor),
            gridCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createKeyboardCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1 / 6))
            
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 5),
                                                  heightDimension: .fractionalHeight(1))
            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            layoutItem.contentInsets = contentInsets
            
            let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
            layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8)
            
            let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
            return sectionLayout
        }
    }
}

extension GridView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridData[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gridData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.identifier, for: indexPath) as! BaseCollectionViewCell
        let cellData = gridData[indexPath.section][indexPath.row]
        cell.configure(with: cellData.key, keyState: cellData.cellState, keyFont: CellFont.gridFont)
        return cell
    }
}
