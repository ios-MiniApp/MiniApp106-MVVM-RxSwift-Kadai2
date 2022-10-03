//
//  calculation.swift
//  MiniApp106-MVVM&RxSwift-Kadai2
//
//  Created by 前田航汰 on 2022/10/03.
//

import Foundation

class Calculation {
    var result = Float()

    func plus(number1: Float, number2: Float) {
        result = number1 + number2
    }

    func minus(number1: Float, number2: Float) {
        result = number1 - number2
    }

    func multiplication(number1: Float, number2: Float) {
        result = number1 * number2
    }

    func division(number1: Float, number2: Float) {
        if number2 == 0 {
            print("エラー：割り算計算時、０で割れない")
            result = 0
        } else {
            result = number1 / number2
        }
    }
}
