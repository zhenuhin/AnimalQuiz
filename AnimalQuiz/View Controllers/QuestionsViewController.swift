//
//  QuestionsViewController.swift
//  AnimalQuiz
//
//  Created by Александр Женухин on 22.01.2021.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var rangedSlider: UISlider! {
        didSet {
            let answersCount = Float(currentAnswers.count - 1)
            rangedSlider.value = answersCount
        }
    }
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var singleButtons: [UIButton]!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var rangedLabels: [UILabel]!
    
    // MARK: - Private Properties
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    private var choosenAnswers: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultsViewController = segue.destination as! ResultsViewController
        resultsViewController.answers = choosenAnswers
    }
    
    // MARK: - IBActions
    @IBAction func singleButtonPressed(_ sender: UIButton) {
        guard let currentIndex = singleButtons.firstIndex(of: sender) else { return }
        
        let currentAnswer = currentAnswers[currentIndex]
        choosenAnswers.append(currentAnswer)
        
        nextQuestion()
    }
    
    @IBAction func multipleAnswerPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                choosenAnswers.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedButtonPressed() {
        let index = lrintf(rangedSlider.value)
        choosenAnswers.append(currentAnswers[index])
        
        nextQuestion()
    }
}

// MARK: - Private Methods
extension QuestionsViewController {
    
    private func updateUI() {
        //Hide stacks
        for stack in [singleStackView, multipleStackView, rangedStackView] {
            stack?.isHidden = true
        }
        // Get current question
        let currentQuestion = questions[questionIndex]
        
        // Set current question for label
        questionLabel.text = currentQuestion.text
        
        // Calculate progress
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // Set progress to progress view
        progressView.setProgress(totalProgress, animated: true)
        
        // Set title
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        // Show current stack
        showCurrentStackView(for: currentQuestion.type)
    }
    
    private func showCurrentStackView(for type: ResponseType) {
        switch type {
        case .single:
            showSingleStackView(with: currentAnswers)
        case .multiple:
            showMultipleStackView(with: currentAnswers)
        case .ranged:
            showRangedStackView(with: currentAnswers)
        }
    }
    
    private func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.text, for: .normal)
        }
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.text
        }
    }
    
    private func showRangedStackView(with answers: [Answer]) {
        rangedStackView.isHidden = false
        
        rangedLabels.first?.text = answers.first?.text
        rangedLabels.last?.text = answers.last?.text
    }
    
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }
}
