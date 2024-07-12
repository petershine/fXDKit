

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
	public static var colorsForTickers: Dictionary<String, UIColor> = [:]
	public static var tickers: Array<String> = ["SPY","DIA","QQQ"]


	@Published open var pricesLineMarks: Dictionary<String, [Price]> = [:]
	@Published public var didFailToRetrieve: Bool = false


	open func startRetrievingTask(tickers: [String], timeout: TimeInterval, isCancellable: Bool = false, completion: ((Bool)->Void?)? = nil) {
		let progressObservable = FXDobservableOverlay(allowUserInteraction: (timeout <= TIMEOUT_LONGER || !isCancellable))
		UIApplication.shared.mainWindow()?.showOverlay(afterDelay: 0.0, observable: progressObservable)


		progressObservable.cancellableTask = Task {
			[weak self] in

			let urlRequests = self?.urlRequestsFromTickers(tickers: tickers, timeout: timeout) ?? []

			var safeDataAndResponse: DataAndResponseActor? = nil
			do {
				safeDataAndResponse = try await URLSession.shared.startSerializedURLRequest(urlRequests: urlRequests, progressConfiguration: progressObservable)
			}
			catch {
				fxdPrint("\(error)")
				if safeDataAndResponse == nil {
					safeDataAndResponse = DataAndResponseActor()
				}
				await safeDataAndResponse?.assignError(error)
			}

			await self?.processDataAndResponseArray(dataAndResponseArray: safeDataAndResponse?.dataAndResponseTuples ?? [])

			await fxdPrint("dataAndResponseArray.count: \(safeDataAndResponse?.count() ?? 0)")
			let didSucceed = await safeDataAndResponse?.count() ?? 0 > 0
			let caughtError = await safeDataAndResponse?.caughtError

			await MainActor.run {
				[weak self] in

				if progressObservable.cancellableTask?.isCancelled ?? false {
					UIAlertController.simpleAlert(withTitle: "CANCELLED", message: nil)
				}
				else if !didSucceed {
					UIAlertController.simpleAlert(withTitle: "Failed to retrieve", message: "FROM: \(self?.urlRequestHOST ?? "")\nTICKERS: \(tickers)")
				}
				else if caughtError != nil {
					let errorTitle = ((caughtError as? URLError)?.errorCode as? String) ?? "(no errorCode)"
					let errorMessage = caughtError?.localizedDescription ?? "(no localizedDescription)"
					UIAlertController.simpleAlert(withTitle: errorTitle, message: errorMessage)
				}

				UIApplication.shared.mainWindow()?.hideOverlay(afterDelay: DURATION_QUARTER)
				completion?(didSucceed)
			}
		}
	}


	open var urlRequestHOST: String = ""
	open func urlRequestsFromTickers(tickers: [String], timeout: TimeInterval) -> [URLRequest] {
		let urlRequests = tickers.map {
			assert(!(urlRequestHOST.isEmpty), "[OVERRIDABLE] urlRequestHOST should not be empty")
			let url = URL(string: "\(urlRequestHOST)/prices/\($0.uppercased())")!
			let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)

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


	enum ChartDataValidation: Error {
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
		let didSucceed = (dataAndResponseArray.count > 0)
		if !didSucceed {
			UIAlertController.simpleAlert(
				withTitle: "Failed to retrieve",
				message: "FROM: \(urlRequestHOST)\nTICKERS: \(tickers)")
		}

		return didSucceed
	}
}


public struct fXDviewChart: View {
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
				.lineStyle(.init(lineWidth: 1))
				.foregroundStyle(Color(uiColor: colorForTicker(ticker: ticker)))
			}
		}
	}
}

extension fXDviewChart {
	fileprivate func colorForTicker(ticker: String) -> UIColor {
		var colorForTicker: UIColor? = FXDdataChart.colorsForTickers[ticker]
		if colorForTicker == nil {
			let nextColor = UIColor.nextColor()
			colorForTicker = nextColor

			DispatchQueue.main.async {
				FXDdataChart.colorsForTickers[ticker] = nextColor
			}
		}

		return colorForTicker!
	}
}



// Example:
extension FXDdataChart {
	public func testChartData() {
		startRetrievingTask(tickers: Self.tickers, timeout: TIMEOUT_DEFAULT, isCancellable: true) {
			[weak self] (didSucceed) in

			self?.didFailToRetrieve = !didSucceed
		}
	}
}
