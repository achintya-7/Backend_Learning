package api

import (
	"fmt"

	db "github.com/achintya-7/simple_bank/db/sqlc"
	"github.com/achintya-7/simple_bank/token"
	"github.com/achintya-7/simple_bank/util"
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
)

type Server struct {
	config     util.Config
	store      *db.Store
	router     *gin.Engine
	tokenMaker token.Maker
}

func NewServer(store *db.Store, config util.Config) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker : %v", err)
	}
	server := &Server{
		store:      store,
		tokenMaker: tokenMaker,
		config:     config,
	}

	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("currency", validCurrency)
	}

	server.setupRoutes()
	return server, nil
}

func (server *Server) setupRoutes() {
	router := gin.Default()

	router.POST("/users", server.createUser)
	router.POST("/users/login", server.loginUser)

	authRoutes := router.Group("/").Use(authMiddleware(server.tokenMaker))

	authRoutes.POST("/accounts", server.createAccount) // This is a method of the Server struct that we need to implement. The reason
	authRoutes.GET("/accounts/:id", server.getAccount) // it needs to be a method of the Server struct is because we have to get access
	authRoutes.GET("/accounts/", server.listAccounts)  // to the store object in order to save new account to the database.

	authRoutes.POST("/transfers", server.createTransferTx)

	server.router = router
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func errorResponse(err error) gin.H {
	return gin.H{
		"error": err.Error(),
	}
}
