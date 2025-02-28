Extension { #name : #SCRAMAuthMechanism }

{ #category : #'*EDAA-EventStore-Voyage' }
SCRAMAuthMechanism >> authenticateUsername: username password: password forcedDatabase: database [
	| nonce firstBare op resp serverFirst parsed iterations salt rnonce without_proof derivedKey clientKey storedKey authMsg clientSig clientProof clientFinal serverKey serverSig |
	nonce := (Random new next asString allButFirst: 2) asByteArray base64Encoded.
	firstBare := 'n=' , username , ',r=' , nonce.
	op := OrderedIdentityDictionary new
		add: #saslStart -> 1;
		add: #mechanism -> self mechanismName;
		add: #payload -> ('n,,' , firstBare) asByteArray;
		add: #autoAuthorize -> 1;
		yourself.
	resp := [ self root command: op database: database ]
		on: MongoCommandError
		do: [ ^ false ].
	serverFirst := resp at: #payload.
	parsed := self parseScramResponse: serverFirst.
	iterations := parsed at: #i.
	salt := parsed at: #s.
	rnonce := parsed at: #r.
	(rnonce beginsWith: nonce)
		ifFalse: [ ^ false	"Server returned an invalid nonce." ].
	without_proof := 'c=biws,r=' , rnonce.
	derivedKey := PBKDF2 new
		hashFunction: self hashFunction;
		password: (self digestUsername: username password: password);
		salt: salt base64Decoded;
		iterations: iterations asInteger;
		length: 20;
		deriveKey.
	clientKey := (HMAC on: self hashFunction new)
		key: derivedKey;
		digestMessage: 'Client Key'.
	storedKey := self hashFunction hashMessage: clientKey.
	authMsg := ','
		join:
			{firstBare.
			serverFirst.
			without_proof}.
	clientSig := (HMAC on: self hashFunction new)
		key: storedKey;
		digestMessage: authMsg.
	clientProof := 'p=' , (clientKey bitXor: clientSig) base64Encoded.
	clientFinal := ','
		join:
			{without_proof.
			clientProof}.
	op := OrderedIdentityDictionary new
		add: #saslContinue -> 1;
		add: #conversationId -> (resp at: #conversationId);
		add: #payload -> clientFinal asByteArray;
		yourself.
	[ resp := self root command: op database: database ]
		on: MongoCommandError
		do: [ ^ false ].
	parsed := self parseScramResponse: (resp at: #payload).
	serverKey := (HMAC on: self hashFunction new)
		key: derivedKey;
		digestMessage: 'Server Key'.
	serverSig := ((HMAC on: self hashFunction new)
		key: serverKey;
		digestMessage: authMsg) base64Encoded.
	(parsed at: #v) = serverSig
		ifFalse: [ ^ false	"Server returned an invalid signature." ].
	(resp at: #done)
		ifFalse: [ op := OrderedIdentityDictionary new
				add: #saslContinue -> 1;
				add: #conversationId -> (resp at: #conversationId);
				add: #payload -> ByteArray new;
				yourself.
			resp := self root command: op database: database.
			^ resp at: #done ].	"ifFalse: SASL conversation failed to complete."
	^ true
]
