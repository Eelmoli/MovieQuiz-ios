import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    struct QuizStepViewModel {
          let image: UIImage
          let question: String
          let questionNumber: String
        }
    struct QuizResultsViewModel {
          let title: String
          let text: String
          let buttonText: String
        }
    private let questions: [QuizQuestion] = [
            QuizQuestion(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Old",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Tesla",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false)
        ]
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
            return QuizStepViewModel(
                image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
                question: model.text, // берём текст вопроса
                questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
        }
        private var currentQuestionIndex: Int = 0
        private var correctAnswers: Int = 0
        
        private func showNextQuestionOrResults() {
          if currentQuestionIndex == questions.count - 1 {
              let text = "Ваш результат: \(correctAnswers) из 10"
                      let viewModel = QuizResultsViewModel(
                          title: "Этот раунд окончен!",
                          text: text,
                          buttonText: "Сыграть ещё раз")
                      show(quiz: viewModel)
          } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
              let nextQuestion = questions[currentQuestionIndex]
                      let viewModel = convert(model: nextQuestion)
                      
                      show(quiz: viewModel)
          }
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
                }
        }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
                    let givenAnswer = true
                    showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
                    let givenAnswer = false
                    showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    
    private func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
        }

        private func show(quiz result: QuizResultsViewModel) {
            let alert = UIAlertController(
                    title: result.title,
                    message: result.text,
                    preferredStyle: .alert)
                
                let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
                    self.currentQuestionIndex = 0
                    // скидываем счётчик правильных ответов
                        self.correctAnswers = 0
                    // заново показываем первый вопрос
                    let firstQuestion = self.questions[self.currentQuestionIndex]
                    let viewModel = self.convert(model: firstQuestion)
                    self.show(quiz: viewModel)
                }
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
        }

}


