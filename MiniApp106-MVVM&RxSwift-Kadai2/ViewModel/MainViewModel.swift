//
//  MainViewModel.swift
//  MiniApp106-MVVM&RxSwift-Kadai2
//
//  Created by 前田航汰 on 2022/10/03.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay

protocol MainViewModelInputs {
    var firstTextFieldObservable: Observable <String> { get }
    var secondTextFieldObservable: Observable <String> { get }
    var calculateMethodSegmentedIndexObservable: Observable <Int> { get }
    var calculateButtonObservable: Observable <Void> { get }
}

protocol MainViewModelOutputs {
    var resultLabelPublishRelay: PublishRelay<String> { get }
}

class MainViewModel: MainViewModelInputs, MainViewModelOutputs {

    // MARK: - Outputs
    var resultLabelPublishRelay = PublishRelay<String>()

    // MARK: - Inputs
    var firstTextFieldObservable: Observable <String>
    var secondTextFieldObservable: Observable <String>
    var calculateMethodSegmentedIndexObservable: Observable <Int>
    var calculateButtonObservable: Observable <Void>

    private let disposeBag = DisposeBag()

    private var firstNumber: Float = 0.0
    private var secondNumber: Float = 0.0
    // +: 0, -: 1, ×: 2, ÷: 3
    private var calculateIndex = 0
    private var calculation = Calculation()

    init(firstTextFieldObservable: Observable<String>,
         secondTextFieldObservable: Observable<String>,
         calculateMethodSegmentedIndexObservable: Observable<Int>,
         calculateButtonObservable: Observable<Void>
    ) {
        self.firstTextFieldObservable = firstTextFieldObservable
        self.secondTextFieldObservable = secondTextFieldObservable
        self.calculateMethodSegmentedIndexObservable = calculateMethodSegmentedIndexObservable
        self.calculateButtonObservable = calculateButtonObservable

        setupBindings()
    }

    private func setupBindings() {

        Observable
            .combineLatest(firstTextFieldObservable, secondTextFieldObservable)
            .subscribe{ firstNumber, secondNumber in
                self.firstNumber = Float(firstNumber) ?? 0.0
                self.secondNumber = Float(secondNumber) ?? 0.0
            }.disposed(by: disposeBag)

        calculateMethodSegmentedIndexObservable.asObservable()
            .subscribe(onNext: { index in
                self.calculateIndex = index
            }).disposed(by: disposeBag)

        calculateButtonObservable.asObservable()
            .subscribe(onNext: { [weak self] in
                if self?.calculateIndex == 0 {
                    self?.calculation.plus(number1: self?.firstNumber ?? 0.0, number2: self?.secondNumber ?? 0.0)
                    self?.resultLabelPublishRelay.accept(String(self?.calculation.result ?? 0.0))
                } else if self?.calculateIndex == 1 {
                    self?.calculation.minus(number1: self?.firstNumber ?? 0, number2: self?.secondNumber ?? 0)
                    self?.resultLabelPublishRelay.accept(String(self?.calculation.result ?? 0.0))
                } else if self?.calculateIndex == 2 {
                    self?.calculation.multiplication(number1: self?.firstNumber ?? 0, number2: self?.secondNumber ?? 0)
                    self?.resultLabelPublishRelay.accept(String(self?.calculation.result ?? 0.0))
                } else {
                    if self?.secondNumber ?? 0 == 0 {
                        self?.resultLabelPublishRelay.accept("割る数には０はダメです")
                    } else {
                        self?.calculation.division(number1: self?.firstNumber ?? 0, number2: self?.secondNumber ?? 0)
                    }
                }


            }).disposed(by: disposeBag)

    }


}
