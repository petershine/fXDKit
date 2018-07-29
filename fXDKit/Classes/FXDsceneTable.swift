

open class FXDsceneTable: UIViewController, FXDscrollableCells {
	@IBOutlet public weak var mainTableview: UITableView!

	open func configureTableCell(_ cell: UITableViewCell?, for indexPath: IndexPath!) {
		fxd_overridable()
	}


	//MARK: FXDprotocolScrollable
	open var mainScrollview: UIScrollView? {
		return mainTableview
	}

	//MARK: FXDscrollableCells
	public lazy var cellOperationQueue: OperationQueue? = {
		return OperationQueue.newSerialQueue(withName: String(describing: self))
	}()
	public lazy var cellOperationDictionary: NSMutableDictionary? = {
		return NSMutableDictionary.init()
	}()

	open var mainCellIdentifier: String {
		fxd_overridable()
		return "CELL_\(String(describing: type(of: self)))"
	}
	open var mainDataSource: NSMutableArray?
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
