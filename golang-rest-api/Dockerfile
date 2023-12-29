FROM golang:1.17
WORKDIR /app
COPY go.* ./
RUN go mod download
COPY . .
RUN go build -o main .
CMD ["/app/main"]