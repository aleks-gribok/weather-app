
import Foundation

//MARK: - Создаем модель под JSON, полученный с сервера с нужными нам параметрами:
// подпишем под протокол Сodable(включает в себя Decodable и Encodable) чтобы можно было разложить из JSON в нашу модель и наоборот.

struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    
    //если нужно поменять название ключа:
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id: Int
}
