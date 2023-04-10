import Foundation
import CoreLocation

//MARK: - создаем PROTOCOL обновления интерфейса, указывая в начале параметров имя делегатора, чтобы не было пересечения имен
protocol NetworkWeatherManagerDelegate: AnyObject {
    func updateInterface(_: NetworkWeatherManager, with currentWeather: CurrentWeather)
}


//MARK: - создаем CLASS который через URLSession получит data с сервера для обновления интерфейса приложения
class NetworkWeatherManager {
    
    //создаем enum в котором прописываем варианты запросов для определения местоположение по названию города или координатам
    enum RequesType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    //создаем делегат который будет обладать методом updateInterface (это будет наш ВьюКонтроллер), и делаем его weak(слабая ссылка) чтобы при закрытии этого экрана он удалялся из памяти
    weak var delegate: NetworkWeatherManagerDelegate?
    
    //создаем универсальную функцию которая определит местоположение по названию города или координатам через запрос, используя enum раскладывая его на switch и подставляя нужный ulr адрес с запросом
    func fetchCurrentWeather (forRequest requestType: RequesType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city): urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longitude): urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        performRequest(withURLString: urlString)
    }
    
    //создаем функцию парсинга через URLSession
    fileprivate func performRequest (withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            if let data = data {
//                Если нужно вывести в консоль:
//                let dataString = String(data: data, encoding: .utf8)
//                print(dataString ?? " ")
                
                //запускаем функцию которая распарсит наш JSON и передаем нашему делегату готовый и разложенный по полочкам currentWeather говый обновить интерфейс
                if let currentWeather = self.parseJSON(withData: data) {
                    self.delegate?.updateInterface(self, with: currentWeather)
                }
            }
        }.resume()
    }
   
    
    //создаем функцию которая распарсит наш JSON по модели CurrentWeatherData и разложит ее в другую модель CurrentWeather, которая будет обновлять интерфейс приложения
    fileprivate func parseJSON (withData data: Data) -> CurrentWeather? {
        
        let decoder = JSONDecoder()
        do {
            // создаем экз модели CurrentWeatherData и пытаемся в нее декодировать/распарсить данные из приходящего JSoN
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            
            //теперь создаем экземпляр структуры из нашей модели CurrentWeather в которой разложились свойства из CurrentWeatherData
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}


