
import Foundation

//MARK: - Создаем отдельную модель, которую будем передавать во ViewController и обновлять интерфейс, которая берет данные с СurrentWeatherData, в который распарсились данные JSON

struct CurrentWeather {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        //какое число будет после точки, столько символов будет после заяпятой
        return String(format: "%.0f", temperature)
    }
    
    let feelsLike: Double
    var feelsLikeString: String {
        return String(format: "%.0f", feelsLike)
    }
    
    let conditionCode: Int
    var systemIconNameString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.min.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    //создаем failable инициализатор который вернет nil в случае неудачи, принимает в себя модель CurrentWeatherData в которой распарсился JSON с сервера
    init? (currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLike = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id //(т.к. это массив с одним значением)
    }
}
