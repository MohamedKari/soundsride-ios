BUILD_DIR:=.grpc_build

API_REPO_URL:=https://github.com/MohamedKari/soundsride
API_REPO_DIR:=spec
PATH_IN_API_REPO:=grpc/soundsride/service

XCODE_APP_NAME:=soundsride
SWIFT_OUTPUT_DIR:=${XCODE_APP_NAME}/grpc

${BUILD_DIR}/spec:
	git clone --single-branch -b main ${API_REPO_URL} ${BUILD_DIR}/${API_REPO_DIR}
	
${BUILD_DIR}/grpc-swift:
	git clone https://github.com/grpc/grpc-swift ${BUILD_DIR}/grpc-swift
	
${BUILD_DIR}/grpc-swift/protoc-gen-swift: ${BUILD_DIR}/grpc-swift
	cd ${BUILD_DIR}/grpc-swift && make plugins

${BUILD_DIR}/grpc-swift/protoc-gen-grpc-swift: ${BUILD_DIR}/grpc-swift
	cd ${BUILD_DIR}/grpc-swift && make plugins

swift-protos: ${BUILD_DIR}/spec ${BUILD_DIR}/grpc-swift/protoc-gen-swift ${BUILD_DIR}/grpc-swift/protoc-gen-grpc-swift
	protoc \
		-I ${BUILD_DIR}/${API_REPO_DIR}/${PATH_IN_API_REPO} \
		--plugin=${BUILD_DIR}/grpc-swift/protoc-gen-swift \
		--swift_opt=Visibility=Public \
		--swift_out=${SWIFT_OUTPUT_DIR} \
		--plugin=${BUILD_DIR}/grpc-swift/protoc-gen-grpc-swift \
		--swift_opt=Visibility=Public \
		--grpc-swift_out=${SWIFT_OUTPUT_DIR} \
		${BUILD_DIR}/${API_REPO_DIR}/${PATH_IN_API_REPO}/*.proto


clean:
	rm -rf .grpc_build