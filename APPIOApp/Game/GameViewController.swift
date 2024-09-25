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
    private var isFirstWord: Bool = true
    private var isCorrectWord: Bool = false
    private var insertIndex: Int = 0
    private var comparedIndex: Int = 0
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
        getSelectedKeys()
        getSavedKeys()
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
            self?.backButtonTapped()
        }))
        alert.addAction(UIAlertAction(title: "Играть еще раз", style: .cancel, handler: { [weak self] _ in
            self?.comparedIndex += 1
        }))
        
        self.present(alert, animated: true)
    }
    
    private func getSelectedKeys() {
        keyboardView.completion = { [weak self] selectedKeys in
            self?.selectedKeys = selectedKeys
            self?.checkButtonActivity()
        }
    }
    
    private func getSavedKeys() {
        guard !coreData.getAllItems().isEmpty else { return }
        
        let lastItem = coreData.getAllItems().last!
        
        if lastItem.isCorrectWord {
            clearGridKeys()
            comparedIndex = Int(lastItem.comparedIndex) + 1
        } else {
           coreData.getAllItems().forEach {
                let cellState = BaseCellState(rawValue: $0.cellState)
                let baseCell = BaseCell(key: $0.key, cellState: cellState!)
                
                gridView.gridData[Int($0.insertIndex)][Int($0.selectedIndex)] = baseCell
            }
            
            insertIndex = Int(lastItem.insertIndex)
            
            if insertIndex == 0 {
                isFirstWord = true
            }
        }
    }
    
    private func updateKeysUI(selectedArray: [String], comparedArray: [String], isCorrectWord: Bool) {
        guard insertIndex < 6 else { return }
        
        var comparedKeyIndex: Int?
        
        for (selectedIndex, selectedElement) in selectedArray.enumerated() {
            if comparedArray.contains(selectedElement) {
                comparedKeyIndex = comparedArray.firstIndex(of: selectedElement)
                
                for (firstIndex, firstKey) in keyboardView.cellData.enumerated() {
                    for (secondIndex, secondKey) in firstKey.enumerated() {
                        if secondKey.key == selectedElement {
                            if selectedIndex == comparedKeyIndex {
                                keyboardView.cellData[firstIndex][secondIndex].cellState = .correct
                                gridView.gridData[insertIndex][selectedIndex].cellState = .correct
                                coreData.createItem(key: selectedElement,
                                                    state: .correct,
                                                    insertIndex: insertIndex,
                                                    selectedIndex: selectedIndex,
                                                    comparedIndex: comparedIndex,
                                                    isCorrectWord: isCorrectWord)
                            } else {
                                keyboardView.cellData[firstIndex][secondIndex].cellState = .wrongPlace
                                gridView.gridData[insertIndex][selectedIndex].cellState = .wrongPlace
                                coreData.createItem(key: selectedElement,
                                                    state: .wrongPlace,
                                                    insertIndex: insertIndex,
                                                    selectedIndex: selectedIndex,
                                                    comparedIndex: comparedIndex,
                                                    isCorrectWord: isCorrectWord)
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
                gridView.gridData[insertIndex][selectedIndex].cellState = .noMatch
                coreData.createItem(key: selectedElement,
                                    state: .noMatch,
                                    insertIndex: insertIndex,
                                    selectedIndex: selectedIndex,
                                    comparedIndex: comparedIndex,
                                    isCorrectWord: isCorrectWord)
            }
            gridView.gridData[insertIndex][selectedIndex].key = selectedElement
        }
    }
    
    private func clearGridKeys() {
        isFirstWord = true
        insertIndex = 0
        
        for (fristIndex, firstKey) in gridView.gridData.enumerated() {
            for (secondIndex, _) in firstKey.enumerated() {
                gridView.gridData[fristIndex][secondIndex].key = ""
                gridView.gridData[fristIndex][secondIndex].cellState = .base
            }
        }
        
        coreData.deleteAllItemsExceptLast(comparedIndex: comparedIndex)
        coreData.updateLastItem(insertIndex: insertIndex)
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
        if !isFirstWord && !coreData.getAllItems().isEmpty {
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
            selectedKeys.removeLast()
            keyboardView.selectedKeys = selectedKeys
        }
    }
    
    @objc private func doneButtonTapped() {
        if selectedKeys.count == 5 {
            
            if isFirstWord {
                isFirstWord = false
                insertIndex = 0
            } else {
                insertIndex += 1
            }
            
            let selectedArray = selectedKeys
            let comparedWord = words[comparedIndex].uppercased()
            var comparedArray: [String] = []
            
            for key in comparedWord {
                comparedArray.append(String(key))
            }
            
            isCorrectWord = selectedArray == comparedArray
            
            print("comparedArray", comparedArray)
            print("selectedArray", selectedArray)
            
            updateKeysUI(selectedArray: selectedArray, comparedArray: comparedArray, isCorrectWord: isCorrectWord)
            
            if isCorrectWord {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.clearGridKeys()
                }
                comparedIndex += 1
            } else if insertIndex == 5 {
                
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

