//
//  ViewController.swift
//  MiniApp106-MVVM&RxSwift-Kadai2
//
//  Created by 前田航汰 on 2022/10/03.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak private var firstTextField: UITextField!
    @IBOutlet weak private var secondTextField: UITextField!
    @IBOutlet weak private var calculateMethodSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var calculateButton: UIButton!
    @IBOutlet weak private var resultLabel: UILabel!

    private let disposeBag = DisposeBag()

    private lazy var mainViewModel = MainViewModel(
        firstTextFieldObservable: firstTextField.rx.text.orEmpty.asObservable(),
        secondTextFieldObservable: secondTextField.rx.text.orEmpty.asObservable(),
        calculateMethodSegmentedIndexObservable: calculateMethodSegmentedControl.rx.selectedSegmentIndex.asObservable(),
        calculateButtonObservable: calculateButton.rx.tap.asObservable()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        mainViewModel.resultLabelPublishRelay
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
    }

}

