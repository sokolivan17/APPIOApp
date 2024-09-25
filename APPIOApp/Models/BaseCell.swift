//
//  BaseCell.swift
//  APPIOApp
//
//  Created by Ваня Сокол on 21.09.2024.
//

import UIKit

enum BaseCellState: String {
    case base
    case correct
    case wrongPlace
    case noMatch
}

struct BaseCell {
    var key: String
    var cellState: BaseCellState = .base
}

extension BaseCell {
    static func getKeyboardData() -> [[BaseCell]] {
        return [
            [BaseCell(key: "Й", cellState: BaseCellState.base),
             BaseCell(key: "Ц", cellState: BaseCellState.base),
             BaseCell(key: "У", cellState: BaseCellState.base),
             BaseCell(key: "К", cellState: BaseCellState.base),
             BaseCell(key: "Е", cellState: BaseCellState.base),
             BaseCell(key: "Н", cellState: BaseCellState.base),
             BaseCell(key: "Г", cellState: BaseCellState.base),
             BaseCell(key: "Ш", cellState: BaseCellState.base),
             BaseCell(key: "Щ", cellState: BaseCellState.base),
             BaseCell(key: "З", cellState: BaseCellState.base),
             BaseCell(key: "Х", cellState: BaseCellState.base),
             BaseCell(key: "Ъ", cellState: BaseCellState.base)],
            
            [BaseCell(key: "Ф", cellState: BaseCellState.base),
             BaseCell(key: "Ы", cellState: BaseCellState.base),
             BaseCell(key: "В", cellState: BaseCellState.base),
             BaseCell(key: "А", cellState: BaseCellState.base),
             BaseCell(key: "П", cellState: BaseCellState.base),
             BaseCell(key: "Р", cellState: BaseCellState.base),
             BaseCell(key: "О", cellState: BaseCellState.base),
             BaseCell(key: "Л", cellState: BaseCellState.base),
             BaseCell(key: "Д", cellState: BaseCellState.base),
             BaseCell(key: "Ж", cellState: BaseCellState.base),
             BaseCell(key: "Э", cellState: BaseCellState.base)],
            
            [BaseCell(key: "Я", cellState: BaseCellState.base),
             BaseCell(key: "Ч", cellState: BaseCellState.base),
             BaseCell(key: "С", cellState: BaseCellState.base),
             BaseCell(key: "М", cellState: BaseCellState.base),
             BaseCell(key: "И", cellState: BaseCellState.base),
             BaseCell(key: "Т", cellState: BaseCellState.base),
             BaseCell(key: "Ь", cellState: BaseCellState.base),
             BaseCell(key: "Б", cellState: BaseCellState.base),
             BaseCell(key: "Ю", cellState: BaseCellState.base)]
        ]
    }
    
    static func getGridData() -> [[BaseCell]] {
        return [
            [BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base)],
            
            [BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base)],
            
            [BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base)],
            
            [BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base)],
            
            [BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base)],
            
            [BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base),
             BaseCell(key: "", cellState: BaseCellState.base)]
        ]
    }
}
