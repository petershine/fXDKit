

public protocol FXDsceneWithCells {
	var mainCellIdentifier: String { get }
	var itemCounts: [Any] { get }

	func registerMainCellNib()
	func numberOfSections(for scrollView: UIScrollView!) -> Int
	func numberOfItems(for scrollView: UIScrollView!, section: Int) -> Int
}

public protocol FXDsceneWithTableCells {
	var cellTitleDictionary: [AnyHashable : Any] { get }
	var cellSubTitleDictionary: [AnyHashable : Any] { get }

	func initializeTableCell(_ cell: UITableViewCell?, for indexPath: IndexPath!)
	func configureTableCell(_ cell: UITableViewCell?, for indexPath: IndexPath!)
	func configureSectionPostionType(forTableCell cell: UITableViewCell?, for indexPath: IndexPath!)
	func backgroundImageForTableCell(at indexPath: IndexPath!) -> UIImage?
	func selectedBackgroundImageForTableCell(at indexPath: IndexPath!) -> UIImage?
	func mainImageForTableCell(at indexPath: IndexPath!) -> UIImage?
	func highlightedMainImageForTableCell(at indexPath: IndexPath!) -> UIImage?
	func accessoryViewForTableCell(at indexPath: IndexPath!) -> UIView?
	func sectionDividerView(forWidth width: CGFloat, andHeight height: CGFloat) -> UIView?
}


open class FXDsceneTable: FXDsceneScroll {

	open var mainDataSource: NSMutableArray?

	@IBOutlet override open var mainScrollview: UIScrollView? {
		get {
			if mainTableview == nil {
				return super.mainScrollview
			}

			return mainTableview
		}
		set {
			super.mainScrollview = newValue
		}
	}

	@IBOutlet open var mainTableview: UITableView?

	override open func viewDidLoad() {
		super.viewDidLoad()

		registerMainCellNib()
	}
}


extension FXDsceneTable: FXDsceneWithCells {
	@objc open var mainCellIdentifier: String {
		let cellIdentifier = "CELL_\(String(describing: type(of: self)))"
		return cellIdentifier
	}

	@objc open var itemCounts: [Any] {
		return []
	}

	@objc open func registerMainCellNib() {
		guard mainTableview != nil,
			Bundle.main.path(forResource: mainCellIdentifier, ofType: "nib") != nil else {
				//MARK: Cell maybe already prototyped in Storyboard, or dynamically instantiated
				return
		}


		fxd_log_func()
		fxdPrint(mainTableview!)
		fxdPrint(mainCellIdentifier)

		let mainCellNib = UINib.init(nibName: mainCellIdentifier, bundle: nil)
		fxdPrint(mainCellNib)

		mainTableview?.register(mainCellNib, forCellReuseIdentifier: mainCellIdentifier)
	}

	public func numberOfSections(for scrollView: UIScrollView!) -> Int {
		var numberOfSections = 1

		if (mainDataSource != nil) {
			//MARK: Assume it's just one array
		}
		else if (itemCounts.count > 0) {
			numberOfSections = itemCounts.count
		}

		return numberOfSections
	}

	public func numberOfItems(for scrollView: UIScrollView!, section: Int) -> Int {
		var numberOfItems = 0

		if (mainDataSource != nil) {
			numberOfItems = (mainDataSource?.count)!
		}
		else if (itemCounts.count > 0) {
			numberOfItems = (itemCounts[section] as? Int)!
		}

		return numberOfItems
	}
}


extension FXDsceneTable: FXDsceneWithTableCells {
	@objc open var cellTitleDictionary: [AnyHashable : Any] {
		return [:]
	}

	@objc open var cellSubTitleDictionary: [AnyHashable : Any] {
		return [:]
	}

	@objc open func initializeTableCell(_ cell: UITableViewCell?, for indexPath: IndexPath!) {	fxd_log_func()
		fxdPrint("NEED TO BE OVERRIDDEN")
	}

	@objc open func configureTableCell(_ cell: UITableViewCell?, for indexPath: IndexPath!) {
		configureSectionPostionType(forTableCell: cell, for: indexPath)

		cell?.textLabel?.text = cellTitleDictionary[indexPath] as? String
		cell?.detailTextLabel?.text = cellSubTitleDictionary[indexPath] as? String
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

	@objc open func configureSectionPostionType(forTableCell cell: UITableViewCell?, for indexPath: IndexPath!) {
		guard let rowCount = itemCounts[indexPath.section] as? Int,
			let fxdCell = cell as? FXDTableViewCell else {
				return
		}

		if (rowCount == 1) {
			fxdCell.sectionPositionCase = .one
		}
		else if (rowCount > 1) {
			if (indexPath.row == 0) {
				fxdCell.sectionPositionCase = .top
			}
			else if (indexPath.row == rowCount-1) {
				fxdCell.sectionPositionCase = .bottom
			}
			else {
				fxdCell.sectionPositionCase = .middle
			}
		}
	}

	@objc open func backgroundImageForTableCell(at indexPath: IndexPath!) -> UIImage? {
		return nil
	}

	@objc open func selectedBackgroundImageForTableCell(at indexPath: IndexPath!) -> UIImage? {
		return nil
	}

	@objc open func mainImageForTableCell(at indexPath: IndexPath!) -> UIImage? {
		return nil
	}

	@objc open func highlightedMainImageForTableCell(at indexPath: IndexPath!) -> UIImage? {
		return nil
	}

	@objc open func accessoryViewForTableCell(at indexPath: IndexPath!) -> UIView? {
		return nil
	}

	@objc open func sectionDividerView(forWidth width: CGFloat, andHeight height: CGFloat) -> UIView? {
		let dividerFrame = CGRect(x: 0.0, y: 0.0, width: width, height: height)

		let sectionDividingView = UIView(frame: dividerFrame)
		sectionDividingView.backgroundColor = .clear

		return sectionDividingView
	}
}

extension FXDsceneTable: UITableViewDataSource {
	open func numberOfSections(in tableView: UITableView) -> Int {
		let sectionCount = numberOfSections(for: tableView)

		return sectionCount
	}

	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		let itemCount = numberOfItems(for: tableView, section: section)

		return itemCount
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