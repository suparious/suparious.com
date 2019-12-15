.PHONY: clean deps check build

clean:
	rm -rf ./pkg/*
	rm -rf ./bin/*
	rm -rf ./src/github*
	rm -rf ./src/golang*

deps:
	#go get github.com/aws/aws-sdk-go/...
	go get github.com/gorilla/mux
	go get github.com/jinzhu/gorm
	go get github.com/rs/cors
	go get golang.org/x/crypto/bcrypt
	go get github.com/joho/godotenv
	go get github.com/lib/pq
	go get github.com/dgrijalva/jwt-go
	go get -u golang.org/x/lint/golint
	go get -u github.com/lib/pq

check:
	golint -set_exit_status src/api
	cd src/api && go vet -c=3 . && cd ../..

install:
	#dep ensure -v
	go install api

