# suparious.com

[![Codeship Status for suparious/suparious.com](https://app.codeship.com/projects/64af4040-7812-0137-1258-029964c0c4c7/status?branch=master)](https://app.codeship.com/projects/350133)

## Phase 1 Completed

As we approach a functional release, v0.1 marks the completion of the base structure that oulines the `concept`.

### Installation

- Setup CodeShip IAM user and access policy in AWS
- jet encrypt IAM keys
- configure `codeship-services.yml` to use the encrypted key

### Deployment

example push to `dev`
```bash
git push --force -u origin HEAD:dev
```

```bash
export GOPATH="C:\Users\shaun\source\suparious.com"
export PORT=5000
make clean
make deps
make check
```

### Testing

Every branch push will get tested

### Data architecture

- [Google Docs](https://docs.google.com/spreadsheets/d/1RaLyNDdCC0CkLVTHnkBN9fb4hnhG1XJiUoRLqz7bLR8)

### References

- [bashstyle](https://github.com/progrium/bashstyle/blob/master/README.md)
- [Standard Go Project Layout](https://github.com/golang-standards/project-layout/blob/master/README.md)
- [How to Write Go Code](https://golang.org/doc/code.html)




### FOR JOLI (To make Local branch checked in)

### To check your own branch

`git checkout -b joli`


### After making changes to local branch
```
git status
git add <filename>
git commit -m "message goes here"
git push -u origin joli

```

### TO DO FOR PROJECT 
```
Create an IAM user that has permissions S3 full access
Follow codeship document to jet-encrypt the IAM keys
Make a git-ignore file that doesnt commit the actual keys
Run those comment out commands 

aws s3 cp --acl public-read web/index.html s3://suparious.com
aws s3 cp --acl public-read web/build.txt s3://suparious.com
aws s3 website s3://suparious.com --index-document index.html
aws s3 sync --delete --acl public-read web s3://suparious.com
```
