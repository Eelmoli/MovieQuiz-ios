import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    private let questionsCount = 10
    private var correctAnswers: Int = 0
    
    private var questionFactory: QuestionFactory?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactoryImpl(delegate: self)
        alertPresenter = AlertPresenterImpl(viewController: self)
        questionFactory?.requestNextQuestion()
        statisticService = StatisticServiceImpl()
        
    }
    
    
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)") // высчитываем номер вопроса
    }
    
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsCount - 1 {
            showFinalResults()
            
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            questionFactory?.requestNextQuestion()
        }
    }
    private func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsCount)
        
        
    // }
    
    let alertModel = AlertModel(title: "Игра окончена!",
                                message: makeResultMessage(),
                                buttonText: "OK",
                                buttonAction: { [weak self] in
        self?.currentQuestionIndex = 0
        self?.correctAnswers = 0
        self?.questionFactory?.requestNextQuestion()
        
    }
    )
    alertPresenter?.show(alertModel: alertModel)
}
        
        private func showAnswerResult(isCorrect: Bool) {
            if isCorrect {
                    correctAnswers += 1
                }
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showNextQuestionOrResults()
                self.imageView.layer.borderWidth = 0
                }
            
        }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
                    let givenAnswer = true
                    showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
                    let givenAnswer = false
                    showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer)
    }
    
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    
    private func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
        }

    private func makeResultMessage() -> String {
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error message")
            return ""
        }
        
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsCount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(accuracy)%"
        let components: [String] = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ]
        let resultMessage = components.joined(separator: "\n")
        return resultMessage
    }

}

extension MovieQuizViewController: QuestionFactoryDelegate {
    
    func didReceiveQuestion(_ question: QuizQuestion) {
        self.currentQuestion = question
        let viewModel = self.convert(model: question)
        self.show(quiz: viewModel)
        
    }
}
