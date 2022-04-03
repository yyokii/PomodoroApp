APP_DIR=${PWD}/App
BUILD_TOOLS_DIR=${PWD}/BuildTools
SWIFTRUN=swift run --package-path ${BUILD_TOOLS_DIR} -c release
BUILD_NUMBER_FILE=${PWD}/.build_number

init:;	swift package resolve --package-path ${BUILD_TOOLS_DIR}; swift package resolve --package-path ${APP_DIR}
clean:;	rm -rf ${BUILD_TOOLS_DIR}/.build; rm -rf ${APP_DIR}/.build;

conf:; ${SWIFTRUN} swift-format --mode dump-configuration > .swift-format


lint:
	${SWIFTRUN} swift-format lint ${BUILD_TOOLS_DIR}/Package.swift
	${SWIFTRUN} swift-format lint ${APP_DIR}/Package.swift
	${SWIFTRUN} swift-format lint -r ${APP_DIR}/Sources
	${SWIFTRUN} swift-format lint -r ${APP_DIR}/Tests

format:
	${SWIFTRUN} swift-format format -p -i  ${BUILD_TOOLS_DIR}/Package.swift
	${SWIFTRUN} swift-format format -p -i  ${APP_DIR}/Package.swift
	${SWIFTRUN} swift-format format -p -i  -r ${APP_DIR}/Sources
	${SWIFTRUN} swift-format format -p -i  -r ${APP_DIR}/Tests