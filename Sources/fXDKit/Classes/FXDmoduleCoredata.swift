

import fXDObjC


extension FXDmoduleCoredata {
	public static var documentSearchPath: String = {
		let searchPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last

		return searchPath ?? ""
	}()
}
