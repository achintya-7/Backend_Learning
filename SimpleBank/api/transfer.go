package api

import (
	"database/sql"
	"errors"
	"fmt"
	"net/http"

	db "github.com/achintya-7/simple_bank/db/sqlc"
	"github.com/achintya-7/simple_bank/token"
	"github.com/gin-gonic/gin"
)

type transferRequest struct {
	ToAccountID   int64  `json:"to_account_id" binding:"required,min=1"`
	FromAccountID int64  `json:"from_account_id" binding:"required,min=1"`
	Amount        int64  `json:"amount" binding:"required,gt=0"`
	Currency      string `json:"currency" binding:"required,currency"`
}

func (server *Server) createTransferTx(ctx *gin.Context) {
	var req transferRequest

	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	fromAccount, valid := server.validationAccount(ctx, req.FromAccountID, req.Currency)
	if !valid {
		return
	}

	authPayload := ctx.MustGet(authorizationPayloadKey).(*token.Payload)
	if fromAccount.Owner != authPayload.Username {
		err := errors.New("account doesnt belong to authenticated user")
		ctx.JSON(http.StatusUnauthorized, errorResponse(err))
		return
	}

	_, valid = server.validationAccount(ctx, req.FromAccountID, req.Currency)
	if !valid {
		return
	}

	arg := db.TransferTxParams{
		FromAccountID: req.FromAccountID,
		ToAccountID:   req.ToAccountID,
		Amount:        req.Amount,
	}

	account, err := server.store.TransferTx(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, account)
}

func (server *Server) validationAccount(ctx *gin.Context, accountId int64, currency string) (db.Account, bool) {
	account, err := server.store.GetAccount(ctx, accountId)
	if err != nil {
		if err != sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return account, false
		}

		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return account, false
	}

	if account.Currency != currency {
		err := fmt.Errorf("Account [%d] currency mismatch %s VS %s", account.ID, account.Currency, currency)
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return account, false
	}

	return account, true

}
