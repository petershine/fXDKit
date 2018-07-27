

open class FXDsceneCollection: FXDsceneTable {

	@IBOutlet override open var mainScrollview: UIScrollView? {
		get {
			if mainCollectionview == nil {
				return super.mainScrollview
			}

			return mainCollectionview
		}
		set {
			super.mainScrollview = newValue
		}
	}

	@IBOutlet open var mainCollectionview: UICollectionView?
}


extension FXDsceneCollection: UICollectionViewDataSource {

	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		let sectionCount = numberOfSections(for: collectionView)

		return sectionCount
	}

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		let itemCount = numberOfItems(for: collectionView, section: section)

		return itemCount
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCellIdentifier, for: indexPath)

		let operation = BlockOperation()

		operation.addExecutionBlock {
			if operation.isCancelled == false {
				// Do something
			}

			OperationQueue.current?.addOperation({
				[weak self] in

				self?.cellOperationQueue?.removeOperation(forKey: indexPath, with: self?.cellOperationDictionary)
			})
		}

		cellOperationQueue?.enqueOperation(operation, forKey: indexPath, with: cellOperationDictionary)

		return cell
	}
}

extension FXDsceneCollection: UICollectionViewDelegate {
	public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

		_ = cellOperationQueue?.cancelOperation(forKey: indexPath, with: cellOperationDictionary)
	}
}
