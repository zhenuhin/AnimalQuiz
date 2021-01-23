//
//  ResultsViewController.swift
//  AnimalQuiz
//
//  Created by Александр Женухин on 22.01.2021.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var answers: [Answer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        updeteResult()
    }

    private func updeteResult() {
        
        var frequencyOfAnimals: [AnimalType: Int] = [:]
        let animals = answers.map { $0.type }
        
        for animal in animals {
            if let animalTypeCount = frequencyOfAnimals[animal] {
                frequencyOfAnimals.updateValue(animalTypeCount + 1, forKey: animal)
            } else {
                frequencyOfAnimals[animal] = 1
            }
        }
        
        let sortedFrequencyOfAnimals = frequencyOfAnimals.sorted { $0.value > $1.value }
        guard let mostFrequencyAnimal = sortedFrequencyOfAnimals.first?.key else { return }
        
        updateUI(with: mostFrequencyAnimal)
    }
    
    private func updateUI(with animal: AnimalType) {
        titleLabel.text = "Вы - \(animal.rawValue ) !"
        descriptionLabel.text = animal.definition
    }
}
