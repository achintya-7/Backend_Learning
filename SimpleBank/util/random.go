package util

import (
	"math/rand"
	"strings"
	"time"
)

const alphabet = "abcdefghijklmnopqrstuvwxyz"

func init() {
	rand.Seed(time.Now().UnixNano())
}

func RandonInt(min, max int64) int64 {
	return min + rand.Int63n(max-min+1)
}

func RandString(n int) string {
	var sb strings.Builder

	k := len(alphabet)

	for i := 0; i < k; i++ {
		c := alphabet[rand.Intn(k)]
		sb.WriteByte(c)
	}

	return sb.String()
}

func RandomOwner() string {
	return RandString(6)
}

func RandomMoney() int64 {
	return RandonInt(0, 1000)
}

func RandomCurrency() string {
	currencies := [] string {"USD", "EUR", "CAD"}
	k := len(currencies)
	return currencies[rand.Intn(k)]
}