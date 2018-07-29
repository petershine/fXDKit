

public protocol FXDsceneWithCells {
	var mainCellIdentifier: String { get }
	var mainDataSource: NSMutableArray? { get set }

	var cellOperationQueue: OperationQueue? { get }
	var cellOperationDictionary: NSMutableDictionary? { get }
}

extension FXDsceneWithCells {
	public var mainCellIdentifier: String {
		fxd_overridable()
		return "CELL_\(String(describing: type(of: self)))"
	}
}


public protocol FXDsceneWithTableCells {
	var cellTitleDictionary: [String : String] { get }
	var cellSubTitleDictionary: [String : String] { get }

	func initializeTableCell(_ cell: UITableViewCell?, for indexPath: IndexPath!)
	func configureTableCell(_ cell: UITableViewCell?, for indexPath: IndexPath!)
	func configureSectionPosition(forTableCell cell: UITableViewCell?, for indexPath: IndexPath!)

	func backgroundImageForTableCell(at indexPath: IndexPath!) -> UIImage?
	func selectedBackgroundImageForTableCell(at indexPath: IndexPath!) -> UIImage?
	func mainImageForTableCell(at indexPath: IndexPath!) -> UIImage?
	func highlightedMainImageForTableCell(at indexPath: IndexPath!) -> UIImage?
	func accessoryViewForTableCell(at indexPath: IndexPath!) -> UIView?
	func sectionDividerView(forWidth width: CGFloat, andHeight height: CGFloat) -> UIView?
}


open class FXDsceneTable: UIViewController, FXDsceneScrollable, FXDsceneWithCells, FXDsceneWithTableCells {
	@IBOutlet open var mainTableview: UITableView?


	open var mainScrollview: UIScrollView? {
		return mainTableview
	}

	open var mainDataSource: NSMutableArray?


	open lazy var cellOperationQueue: OperationQueue? = {
		return OperationQueue.newSerialQueue(withName: String(describing: self))
	}()
	open lazy var cellOperationDictionary: NSMutableDictionary? = {
		return NSMutableDictionary.init()
	}()


	open var cellTitleDictionary: [String : String] {
		return [:]
	}

	open var cellSubTitleDictionary: [String : String] {
		return [:]
	}

	open func initializeTableCell(_ cell: UITableViewCell?, for indexPath: IndexPath!) {
		fxd_overridable()
	}

	open func configureTableCell(_ cell: UITableViewCell?, for indexPath: IndexPath!) {
		cell?.textLabel?.text = cellTitleDictionary[indexPath.stringKey]
		cell?.detailTextLabel?.text = cellSubTitleDictionary[indexPath.stringKey]
		cell?.accessoryView = accessoryViewForTableCell(at: indexPath)

		if let fxdCell = cell as? FXDTableViewCell {
			let backgroundImage = backgroundImageForTableCell(at: indexPath)
			let highlightedImage = selectedBackgroundImageForTableCell(at: indexPath)
			fxdCell.customizeBackground(with: backgroundImage, withHighlightedImage: highlightedImage)

			let mainImage = mainImageForTableCell(at: indexPath)
			let highlightedMainImage = highlightedMainImageForTableCell(at: indexPath)
			fxdCell.customize(withMainImage: mainImage, withHighlightedMainImage: highlightedMainImage)
		}
	}

	open func configureSectionPosition(forTableCell cell: UITableViewCell?, for indexPath: IndexPath!) {
		guard let fxdCell = cell as? FXDTableViewCell else {
			return
		}

		let itemCount = tableView(mainTableview!, numberOfRowsInSection: indexPath.section)

		if (itemCount == 1) {
			fxdCell.positionCase = .single
		}
		else if (itemCount > 1) {
			if (indexPath.row == 0) {
				fxdCell.positionCase = .top
			}
			else if (indexPath.row == itemCount-1) {
				fxdCell.positionCase = .bottom
			}
			else {
				fxdCell.positionCase = .middle
			}
		}
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

	open func accessoryViewForTableCell(at indexPath: IndexPath!) -> UIView? {
		return nil
	}

	open func sectionDividerView(forWidth width: CGFloat, andHeight height: CGFloat) -> UIView? {
		let dividerFrame = CGRect(x: 0.0, y: 0.0, width: width, height: height)

		let sectionDividingView = UIView(frame: dividerFrame)
		sectionDividingView.backgroundColor = .clear

		return sectionDividingView
	}
}

extension FXDsceneTable {
	override open func willMove(toParentViewController parent: UIViewController?) {
		if parent == nil {
			cellOperationQueue?.resetOperationQueueAndDictionary(cellOperationDictionary)
		}

		super.willMove(toParentViewController: parent)
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

			initializeTableCell(cell, for: indexPath)
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
