package api

import (
	db "github.com/achintya-7/simple_bank/db/sqlc"
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
)

type Server struct {
	store  *db.Store
	router *gin.Engine
}

func NewServer(store *db.Store) *Server {
	server := &Server{store: store}
	router := gin.Default()

	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("currency", validCurrency)
	}

	// TODO: add routes
	router.POST("/accounts", server.createAccount) // This is a method of the Server struct that we need to implement. The reason
	router.GET("/accounts/:id", server.getAccount) // it needs to be a method of the Server struct is because we have to get access
	router.GET("/accounts/", server.listAccounts)  // to the store object in order to save new account to the database.
	router.POST("/transfers", server.createTransferTx)
	router.POST("/users", server.createUser)

	server.router = router
	return server
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func errorResponse(err error) gin.H {
	return gin.H{
		"error": err.Error(),
	}
}
