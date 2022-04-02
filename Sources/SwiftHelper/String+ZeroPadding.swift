extension String {
    public func zeroPadding(toSize: Int) -> String {
        var padded = self
        for _ in 0..<(toSize - count) {
            padded = "0" + padded
        }
        return padded
    }
}
