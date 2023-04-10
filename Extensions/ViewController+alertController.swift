
import UIKit

// MARK: - создаем extension для ViewController с UIAlertController. В саму функцию добавляем complitionHandler и прописываем @escaping так как это сбегающее замыкание

extension ViewController {
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, complitionHandler: @escaping (String) -> Void) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        
        //добавляем рандомные города в плейсхолдер
        ac.addTextField { tf in
            let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                
                //Заменяем пробелы на "%20" чтобы в строке читались несколько слов
                let city = cityName.split(separator: " ").joined(separator: "%20")
                complitionHandler(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}
