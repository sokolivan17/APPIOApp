//
//  GameViewController.swift
//  APPIOApp
//
//  Created by Ваня Сокол on 20.09.2024.
//

import UIKit

final class GameViewController: UIViewController {
    
    private let coreData = CoreDataService.shared
    private let words = ComparedWordsService().comparedWords.words
    private let keyboardView = KeyboardView()
    private let gridView = GridView()
    private let clearButton = UIButton()
    private let doneButton = UIButton()
    private var gameParameters = GameParameters()
    
    private var selectedKeys: [String] = [] {
        didSet {
            checkButtonActivity()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupNavigationBar()
        setupGridView()
        setupKeyboardView()
        setupButtons()
        checkButtonActivity()
        getSavedKeys()
        getSelectedKeys()
    }

    private func setupNavigationBar() {
        title = "5 букв"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backImage"), style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    private func setupGridView() {
        view.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridView.topAnchor.constraint(equalTo: view.topAnchor, constant: 169),
            gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gridView.heightAnchor.constraint(equalToConstant: 420)
        ])
    }
    
    private func setupKeyboardView() {
        view.addSubview(keyboardView)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 623),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func setupButtons() {
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        clearButton.layer.cornerRadius = 4
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.layer.cornerRadius = 4
        
        view.addSubview(clearButton)
        view.addSubview(doneButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            doneButton.bottomAnchor.constraint(equalTo: keyboardView.bottomAnchor, constant: -2.5),
            doneButton.heightAnchor.constraint(equalToConstant: 48),
            doneButton.widthAnchor.constraint(equalToConstant: 43),
            
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            clearButton.bottomAnchor.constraint(equalTo: keyboardView.bottomAnchor, constant: -2.5),
            clearButton.heightAnchor.constraint(equalToConstant: 48),
            clearButton.widthAnchor.constraint(equalToConstant: 43),
        ])
    }
    
    private func showAlert(with word: String) {
        let alert = UIAlertController(title: nil, 
                                      message: "К сожалению попытки закончились - загаданное слово было \(word), но вы можете сыграть еще раз",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Выйти из игры", style: .default, handler: { [weak self] _ in
            self?.coreData.deleteAllItems()
            self?.backButtonTapped()
        }))
        alert.addAction(UIAlertAction(title: "Играть еще раз", style: .cancel, handler: { [weak self] _ in
            self?.gameParameters.comparedIndex += 1
        }))
        
        self.present(alert, animated: true)
    }
    
    private func getSelectedKeys() {
        keyboardView.completion = { [weak self] selectedKeys in
            self?.selectedKeys = selectedKeys
            self?.checkButtonActivity()
            
            let key = selectedKeys.last!
            let selectedIndex = selectedKeys.lastIndex(of: key)!
            self?.showSelectedKeyOnGridView(key: key, selectedIndex: selectedIndex)
        }
    }
    
    private func showSelectedKeyOnGridView(key: String, selectedIndex: Int) {
        if coreData.getAllItems().isEmpty {
            gridView.gridData[gameParameters.insertIndex][selectedIndex].key = key
        } else if Int(coreData.getAllItems().last!.insertIndex) < 5 {
            gridView.gridData[gameParameters.insertIndex + 1][selectedIndex].key = key
        }
    }
    
    private func removeLastKeyOnGridView(keyIndex: Int) {
        if coreData.getAllItems().isEmpty {
            gridView.gridData[gameParameters.insertIndex][keyIndex].key = ""
        } else if Int(coreData.getAllItems().last!.insertIndex) < 5 {
            gridView.gridData[gameParameters.insertIndex + 1][keyIndex].key = ""
        }
    }
    
    private func getSavedKeys() {
        guard !coreData.getAllItems().isEmpty else { return }
        
        let lastItem = coreData.getAllItems().last!
        
        if lastItem.isCorrectWord {
            gameParameters.comparedIndex = Int(lastItem.comparedIndex) + 1
        } else if lastItem.insertIndex == 5 {
            gameParameters.comparedIndex = Int(lastItem.comparedIndex) + 1
        } else {
            let filteredItems = coreData.getAllItems().filter { key in
                key.comparedIndex == lastItem.comparedIndex
            }
            
            filteredItems.forEach {
                let cellState = BaseCellState(rawValue: $0.cellState)
                let baseCell = BaseCell(key: $0.key, cellState: cellState!)
                
                gridView.gridData[Int($0.insertIndex)][Int($0.selectedIndex)] = baseCell
               print("insertIndex \($0.insertIndex) , selectedIndex \($0.selectedIndex) , comparedIndex \($0.comparedIndex) ")
            }
            
            gameParameters.comparedIndex = Int(lastItem.comparedIndex)
            gameParameters.insertIndex = Int(lastItem.insertIndex)
            gameParameters.isFirstWord = false
        }
    }
    
    private func updateKeysUI(selectedArray: [String], comparedArray: [String], isCorrectWord: Bool) {
        guard gameParameters.insertIndex < 6 else { return }
        
        var comparedKeyIndex: Int?
        
        for (selectedIndex, selectedElement) in selectedArray.enumerated() {
            if comparedArray.contains(selectedElement) {
                comparedKeyIndex = comparedArray.firstIndex(of: selectedElement)
                
                for (firstIndex, firstKey) in keyboardView.cellData.enumerated() {
                    for (secondIndex, secondKey) in firstKey.enumerated() {
                        if secondKey.key == selectedElement {
                            if selectedIndex == comparedKeyIndex {
                                keyboardView.cellData[firstIndex][secondIndex].cellState = .correct
                                gridView.gridData[gameParameters.insertIndex][selectedIndex].cellState = .correct
                                coreData.createItem(key: selectedElement,
                                                    state: .correct,
                                                    gameParameters: gameParameters,
                                                    selectedIndex: selectedIndex)
                            } else {
                                keyboardView.cellData[firstIndex][secondIndex].cellState = .wrongPlace
                                gridView.gridData[gameParameters.insertIndex][selectedIndex].cellState = .wrongPlace
                                coreData.createItem(key: selectedElement,
                                                    state: .wrongPlace,
                                                    gameParameters: gameParameters,
                                                    selectedIndex: selectedIndex)
                            }
                        }
                    }
                }
            } else {
                for (firstIndex, firstKey) in keyboardView.cellData.enumerated() {
                    for (secondIndex, secondKey) in firstKey.enumerated() {
                        if secondKey.key == selectedElement {
                            keyboardView.cellData[firstIndex][secondIndex].cellState = .noMatch
                        }
                    }
                }
                gridView.gridData[gameParameters.insertIndex][selectedIndex].cellState = .noMatch
                coreData.createItem(key: selectedElement,
                                    state: .noMatch,
                                    gameParameters: gameParameters,
                                    selectedIndex: selectedIndex)
            }
            gridView.gridData[gameParameters.insertIndex][selectedIndex].key = selectedElement
        }
    }
    
    private func clearGridKeys() {
        gameParameters.isFirstWord = true
        
        for (fristIndex, firstKey) in gridView.gridData.enumerated() {
            for (secondIndex, _) in firstKey.enumerated() {
                gridView.gridData[fristIndex][secondIndex].key = ""
                gridView.gridData[fristIndex][secondIndex].cellState = .base
            }
        }
        gameParameters.insertIndex = 0
    }
    
    private func checkButtonActivity() {
        if selectedKeys.isEmpty {
            clearButton.setImage(UIImage(named: "clearDisabled"), for: .normal)
            clearButton.backgroundColor = .systemGray
            clearButton.isUserInteractionEnabled = false
            
            doneButton.setImage(UIImage(named: "doneDisabled"), for: .normal)
            doneButton.backgroundColor = .systemGray
            doneButton.isUserInteractionEnabled = false
            
        } else if selectedKeys.count == 5 {
            doneButton.backgroundColor = .white
            doneButton.isUserInteractionEnabled = true
            doneButton.setImage(UIImage(named: "doneActive"), for: .normal)
        } else if selectedKeys.count < 5 {
            clearButton.backgroundColor = .white
            clearButton.isUserInteractionEnabled = true
            clearButton.setImage(UIImage(named: "clearActive"), for: .normal)
            
            doneButton.backgroundColor = .systemGray
            doneButton.isUserInteractionEnabled = false
            doneButton.setImage(UIImage(named: "doneDisabled"), for: .normal)
            
        }
    }
    
    @objc private func backButtonTapped() {
        if !coreData.getAllItems().isEmpty {
            let welcomeViewController = navigationController?.viewControllers.first as? WelcomeViewController
            welcomeViewController?.hasSavedGame = true
            navigationController?.popViewController(animated: true)
            
        } else {
            let welcomeViewController = navigationController?.viewControllers.first as? WelcomeViewController
            welcomeViewController?.hasSavedGame = false
            navigationController?.popViewController(animated: true)
            coreData.deleteAllItems()
        }
        
    }
    
    @objc private func clearButtonTapped() {
        if !selectedKeys.isEmpty {
            let key = selectedKeys.last!
            let keyIndex = selectedKeys.lastIndex(of: key)!
            
            selectedKeys.removeLast()
            keyboardView.selectedKeys = selectedKeys
            removeLastKeyOnGridView(keyIndex: keyIndex)
        }
    }
    
    @objc private func doneButtonTapped() {
        if selectedKeys.count == 5 {
            
            if gameParameters.isFirstWord {
                gameParameters.isFirstWord = false
                gameParameters.insertIndex = 0
            } else {
                gameParameters.insertIndex += 1
            }
            
            let selectedArray = selectedKeys
            let comparedWord = words[gameParameters.comparedIndex].uppercased()
            var comparedArray: [String] = []
            
            for key in comparedWord {
                comparedArray.append(String(key))
            }
            
            gameParameters.isCorrectWord = selectedArray == comparedArray
            
            print("comparedArray", comparedArray)
            print("selectedArray", selectedArray)
            
            updateKeysUI(selectedArray: selectedArray,
                         comparedArray: comparedArray,
                         isCorrectWord: gameParameters.isCorrectWord)
            
            if gameParameters.isCorrectWord {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.clearGridKeys()
                }
                gameParameters.comparedIndex += 1
            } else if gameParameters.insertIndex == 5 {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.clearGridKeys()
                    self?.showAlert(with: comparedWord)
                }
            }
            
            selectedKeys = []
            keyboardView.selectedKeys = []
        }
    }
}

