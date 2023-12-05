

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
	@Published public var didFailToRetrieve: Bool = false

	open var urlRequestHOST: String = ""

	open func startRetrievingTask(tickers: [String], completion: ((Bool)->Void?)? = nil) {
		let progressConfiguration = FXDconfigurationInformation(shouldIgnoreUserInteraction: true)
		UIApplication.shared.mainWindow()?.showWaitingView(afterDelay: 0.0, configuration: progressConfiguration)

		Task {
			[weak self] in

			let urlRequests = self?.urlRequestsFromTickers(tickers: tickers) ?? []

			let dataAndResponseArray = await URLSession.shared.startSerializedURLRequest(urlRequests: urlRequests, progressConfiguration: progressConfiguration)

			self?.processDataAndResponseArray(dataAndResponseArray: dataAndResponseArray)

			DispatchQueue.main.async {
				[weak self] in

				let didFail = self?.evaluateAndAlertIfFailed(dataAndResponseArray: dataAndResponseArray, tickers: tickers)
				UIApplication.shared.mainWindow()?.hideWaitingView(afterDelay: DURATION_QUARTER)

				completion?(didFail ?? false)
			}
		}
	}

	open func urlRequestsFromTickers(tickers: [String]) -> [URLRequest] {
		let urlRequests = tickers.map {
			assert(!(urlRequestHOST.isEmpty), "[OVERRIDABLE] urlRequestHOST should not be empty")
			let url = URL(string: "\(urlRequestHOST)/prices/\($0.uppercased())")!
			let request = URLRequest(url: url)
			return request
		}

		return urlRequests
	}

	open func processDataAndResponseArray(dataAndResponseArray: [(Data, URLResponse)]) {
		for (data, response) in dataAndResponseArray {
			fxdPrint("\(response)")
			do {
				try processData(jsonData: data)
			}
			catch {
				fxdPrint("\(error)")
			}
		}
	}


	public enum ChartDataValidation: Error {
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


	open func evaluateAndAlertIfFailed(dataAndResponseArray: [(Data, URLResponse)], tickers: [String]) -> Bool {
		fxdPrint("dataAndResponseArray.count: \(dataAndResponseArray.count)")
		let didFail = (dataAndResponseArray.count == 0)
		if didFail {
			UIAlertController.simpleAlert(
				withTitle: "Failed to retrieve",
				message: "FROM: \(urlRequestHOST)\nTICKERS: \(tickers)")
		}

		return didFail
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

		startRetrievingTask(tickers: tickers) { 
			[weak self] (didFail) in

			self?.didFailToRetrieve = didFail
		}
	}
}
