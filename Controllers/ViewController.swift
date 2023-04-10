import UIKit
import CoreLocation

class ViewController: UIViewController {
    //MARK: - Property
    var networkWeatherManager = NetworkWeatherManager()
    
    //создаем locationManager и назначаем ему делегата для определения координат пользователя
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        
        //определяем точность работы (варианты в документации)
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        
        //запрашиваем у пользователя доступ к геопозиции и надо в Info.plist добавить ключ "Privacy - Location When In Use Usage Description" и подпись - "Необходимо предоставить данные о вашем местоположении."
        lm.requestWhenInUseAuthorization()
        
        return lm
    }()
    //MARK: - Outlets
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //проверяем выключена ли настройка пользователя о определении геопозиции
        DispatchQueue.global().async {
            
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestLocation()
            }
            // При использовании метода (requestLocation) связанный с ним делегат должен реализовать locationManager(_:didUpdateLocations:) and locationManager(_:didFailWithError:) методы.
        }
        
        //delegate
        networkWeatherManager.delegate = self
    }
    //MARK: - Actions
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.networkWeatherManager.fetchCurrentWeather(forRequest: .cityName(city: city))
        }
    }
}
//MARK: - Delegate для обновления интерфейса
extension ViewController: NetworkWeatherManagerDelegate {
    
    func updateInterface(_: NetworkWeatherManager, with currentWeather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = currentWeather.cityName
            self.temperatureLabel.text = currentWeather.temperatureString
            self.feelsLikeTemperatureLabel.text = currentWeather.feelsLikeString
            self.weatherIconImageView.image = UIImage(systemName: currentWeather.systemIconNameString)
        }
    }
}
//MARK: - CLLocationManagerDelegate для определения позиции пользователя
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //так как location в этом методе это массив геопозиций, то надо получить последнюю позицию в массиве
        guard let location = locations.last else { return }
        //берем ширину
        let latitude = location.coordinate.latitude
        //берем долготу
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(forRequest: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

