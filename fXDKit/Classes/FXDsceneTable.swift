

public protocol FXDscrollableCells: FXDsceneScrollable {
	var mainCellIdentifier: String { get }
	var mainDataSource: NSMutableArray? { get set }

	var cellOperationQueue: OperationQueue? { get }
	var cellOperationDictionary: NSMutableDictionary? { get }

	func configureTableCell(_ cell: UITableViewCell?, for indexPath: IndexPath!)

	func backgroundImageForTableCell(at indexPath: IndexPath!) -> UIImage?
	func selectedBackgroundImageForTableCell(at indexPath: IndexPath!) -> UIImage?
	func mainImageForTableCell(at indexPath: IndexPath!) -> UIImage?
	func highlightedMainImageForTableCell(at indexPath: IndexPath!) -> UIImage?
}


open class FXDsceneTable: UIViewController, FXDscrollableCells {
	deinit {
		cellOperationQueue?.resetOperationQueueAndDictionary(cellOperationDictionary)
	}


	@IBOutlet open var mainTableview: UITableView?


	open var mainScrollview: UIScrollView? {
		return mainTableview
	}

	open var mainCellIdentifier: String {
		fxd_overridable()
		return "CELL_\(String(describing: type(of: self)))"
	}
	open var mainDataSource: NSMutableArray?

	open lazy var cellOperationQueue: OperationQueue? = {
		return OperationQueue.newSerialQueue(withName: String(describing: self))
	}()
	open lazy var cellOperationDictionary: NSMutableDictionary? = {
		return NSMutableDictionary.init()
	}()

	open func configureTableCell(_ cell: UITableViewCell?, for indexPath: IndexPath!) {
		guard let fxdCell = cell as? FXDTableViewCell else {
			return
		}

		let backgroundImage = backgroundImageForTableCell(at: indexPath)
		let highlightedImage = selectedBackgroundImageForTableCell(at: indexPath)
		fxdCell.customizeBackground(with: backgroundImage, withHighlightedImage: highlightedImage)

		let mainImage = mainImageForTableCell(at: indexPath)
		let highlightedMainImage = highlightedMainImageForTableCell(at: indexPath)
		fxdCell.customize(withMainImage: mainImage, withHighlightedMainImage: highlightedMainImage)
	}
	open func backgroundImageForTableCell(at indexPath: IndexPath!) -> UIImage? {
		return nil
	}
	open func selectedBackgroundImageForTableCell(at indexPath: IndexPath!) -> UIImage? {
		return nil
	}
	open func mainImageForTableCell(at indexPath: IndexPath!) -> UIImage? {
		return nil
	}
	open func highlightedMainImageForTableCell(at indexPath: IndexPath!) -> UIImage? {
		return nil
	}
}


extension FXDsceneTable: UITableViewDataSource {
	open func numberOfSections(in tableView: UITableView) -> Int {
		return 1	//MARK: Assume it's often just one array
	}

	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (mainDataSource != nil) ? (mainDataSource?.count)! : 0
	}

	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: mainCellIdentifier)

		if cell == nil {
			cell = FXDTableViewCell.init(style: .subtitle, reuseIdentifier: mainCellIdentifier)
		}

		configureTableCell(cell, for: indexPath)

		return cell!
	}
}

extension FXDsceneTable: UITableViewDelegate {
	open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		_ = cellOperationQueue?.cancelOperation(forKey: indexPath, with: cellOperationDictionary)
	}
}
