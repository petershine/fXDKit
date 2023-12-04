

import SwiftUI
import Charts


public struct Price: Decodable, Identifiable {
	public var id: ObjectIdentifier?

	var timestamp: Date
	var closed: Double

	private enum CodingKeys: String, CodingKey {
		case t
		case c
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		let timeInterval = try (container.decode(Double.self, forKey: .t) / 1000.0)
		timestamp = Date.init(timeIntervalSince1970: timeInterval)
		closed = try container.decode(Double.self, forKey: .c)
	}
}


open class FXDdataChart: NSObject, ObservableObject {
	@Published open var pricesLineMarks: Dictionary<String, [Price]> = [:]

	open var urlRequestHOST: String = ""

	private enum ChartDataValidation: Error {
		case pricesWithoutTicker
		case notDecodable
	}

	open func processData(jsonData: Data) throws {
		let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
		guard let ticker = jsonDictionary?.keys.first as? String else {
			throw ChartDataValidation.pricesWithoutTicker
		}

		guard let pricesJSON = jsonDictionary?[ticker],
			  let pricesData = try? JSONSerialization.data(withJSONObject: pricesJSON),
			  let prices = try? JSONDecoder().decode([Price].self, from: pricesData) else {
			throw ChartDataValidation.notDecodable
		}


		let sortedPrices = prices.sorted(by: { $0.timestamp < $1.timestamp })
		DispatchQueue.main.async {
			[weak self] in
			self?.pricesLineMarks[ticker] = sortedPrices
		}
	}
}


public struct FXDswiftuiChart: View {
	@Binding var pricesLineMarks: Dictionary<String, [Price]>

	public init(pricesLineMarks: Binding<Dictionary<String, [Price]>>) {
		_pricesLineMarks = pricesLineMarks
	}

	public var body: some View {
		Chart {
			ForEach(Array(pricesLineMarks.keys), id: \.self) {
				ticker in

				let prices = pricesLineMarks[ticker] ?? []
				ForEach(prices) {
					price in
					LineMark(
						x: .value("Date", price.timestamp, unit: .day),
						y: .value("Price", price.closed),
						series: .value(ticker, ticker)
					)
				}
			}
		}
	}
}



// Example:
extension FXDdataChart {
	public func testChartData() {
		let progressConfiguration = FXDconfigurationInformation(shouldIgnoreUserInteraction: true)
		UIApplication.shared.mainWindow()?.showWaiting(configuration: progressConfiguration)

		let tickers = [
			"avgo",
			"AAPL",
			"MSFT",
			"UNH",
			"ARM",
		]+[
			//"GOOG",	//TODO: need splited price tracking
			//"TSLA",
		]

		let urlRequests = tickers.map {
			assert(!(urlRequestHOST.isEmpty), "[OVERRIDABLE] urlRequestHOST should not be empty")
			let url = URL(string: "\(urlRequestHOST)/prices/\($0.uppercased())")!
			let request = URLRequest(url: url)
			return request
		}


		Task {
			let dataTuples = await URLSession.shared.startSerializedURLRequest(urlRequests: urlRequests, progressConfiguration: progressConfiguration)

			for (data, _) in dataTuples {
				do {
					try self.processData(jsonData: data)
				}
				catch {
					fxdPrint("\(error)")
				}
			}

			DispatchQueue.main.async {
				UIApplication.shared.mainWindow()?.hideWaitingView(afterDelay: DURATION_QUARTER)
			}
		}
	}
}
