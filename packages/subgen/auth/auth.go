package auth

import (
	"context"

	"golang.org/x/crypto/bcrypt"
)

type Authenticator interface {
	Auth(ctx context.Context, token string) error
}

func NewPasswordAuthenticator(hashedPassword string) Authenticator {
	return &passwordAuthenticator{hashedPassword}
}

type passwordAuthenticator struct {
	hashedPassword string
}

func (p *passwordAuthenticator) Auth(ctx context.Context, token string) error {
	hashedPassword := []byte(p.hashedPassword)
	password := []byte(token)
	return bcrypt.CompareHashAndPassword(hashedPassword, password)
}
