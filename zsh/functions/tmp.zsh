
# Create and switch context to the temporary directory
@tmp() {
	cd $(mktemp -d)
}
