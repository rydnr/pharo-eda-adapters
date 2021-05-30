"
* Class: EDAStompTopicListener

Manages the details of connecting, subscribing, and unsubscribing, to Stomp queues.

* Responsibility:

Contains the configuration settings used by Stomp clients, and manages basic operations such as subscribing and unsubscribing.

* Collaborators:

Children (not instances) of this class would be configured via the Settings framework .

* Public API and Key Messages

- subscribe:subscribe to a queue.
- unsubscribe: unsubscribe to a queue.
- subscriptionId: the id of the listener.
"
Class {
	#name : #EDAAStompTopicListener,
	#superclass : #EDATopicListener,
	#traits : 'EDACTPrintOnHelper + EDACTErrorHelper',
	#classTraits : 'EDACTPrintOnHelper classTrait + EDACTErrorHelper classTrait',
	#instVars : [
		'client',
		'listenerProcess',
		'subscriptionId',
		'config',
		'commandListenerClientDebug'
	],
	#classInstVars : [
		'username',
		'queue',
		'port',
		'host',
		'ack',
		'durable',
		'password',
		'prefetchCount',
		'timeout'
	],
	#category : #'EDAA-Messaging-Stomp'
}

{ #category : #logging }
EDAAStompTopicListener class >> logDebugMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings debugEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'DEBUG'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAAStompTopicListener class >> logErrorMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings errorEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'ERROR'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #accessing }
EDAAStompTopicListener class >> logFinish: message usingClient: aClient withConfig: aConfig [
	self logInfoMessage: 'Published message ', message greaseString , ' in ', aConfig destination greaseString , '.'
]

{ #category : #logging }
EDAAStompTopicListener class >> logInfoMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings infoEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'INFO '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #accessing }
EDAAStompTopicListener class >> logReceivingMessage: message usingClient: aClient from: aSource [
	self
		logInfoMessage: 'Receiving message in ' , aSource greaseString , '.'
]

{ #category : #logging }
EDAAStompTopicListener class >> logTraceMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings traceEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'TRACE'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAAStompTopicListener class >> logWarningMessage: aMessage beautify: aBoolean [
	^ EDACLoggingSettings warningEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'WARN '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #'instance creation' }
EDAAStompTopicListener class >> withConfig: aConfig [
	| result |
	result := self new.
	result config: aConfig.
	result client: (result buildClientWith: aConfig).
	^ result
]

{ #category : #lifecycle }
EDAAStompTopicListener >> asyncOnMessageDo: aBlock usingClient: aClient withConfig: aConfig [
	| result |
	result := [ self syncOnMessageDo: aBlock usingClient: aClient withConfig: aConfig ] newProcess.
	result priority: Processor systemBackgroundPriority.
	^ result
]

{ #category : #initialization }
EDAAStompTopicListener >> buildClientWith: config [
	| result |
	result := StampClient new.
	result login: config username.
	result passcode: config password.
	result host: config host.
	result port: config port.
	result timeout: config timeout.
	^ result
]

{ #category : #accessing }
EDAAStompTopicListener >> buildIdUsingClient: aClient withConfig: config [
	^ aClient nextId , '-', config destination
]

{ #category : #accessing }
EDAAStompTopicListener >> client [
	^ client
]

{ #category : #accessing }
EDAAStompTopicListener >> client: aClient [
	client := aClient
]

{ #category : #lifecycle }
EDAAStompTopicListener >> close [
	[ self client close ]
		on: StampError , PrimitiveFailed, ZnIncomplete
		do: [ :ex |
			self
				logErrorMessage:
					(String
						streamContents: [ :s |
							s
								nextPutAll: 'Error closing Stamp connection: ';
								nextPutAll: ex greaseString ]) ]
]

{ #category : #accessing }
EDAAStompTopicListener >> config [
	^ config
]

{ #category : #accessing }
EDAAStompTopicListener >> config: aConfig [
	config := aConfig
]

{ #category : #lifecycle }
EDAAStompTopicListener >> forceUnsubscribe [
	self subscriptionId: nil
]

{ #category : #accessing }
EDAAStompTopicListener >> listenerProcess [
	^ listenerProcess
]

{ #category : #accessing }
EDAAStompTopicListener >> listenerProcess: aProcess [
	listenerProcess := aProcess
]

{ #category : #initialization }
EDAAStompTopicListener >> logFinish: message usingClient: aClient withConfig: aConfig [
	self logInfoMessage: '<< Finished processing message: ', message greaseString , ' from ', aConfig queue greaseString , '.'
]

{ #category : #initialization }
EDAAStompTopicListener >> logInit: message usingClient: aClient withConfig: aConfig [
	self logInfoMessage: '>> Processing incoming message: ', message greaseString , ' from ', aConfig queue greaseString , '.'

]

{ #category : #accessing }
EDAAStompTopicListener >> nextId [
	^ self buildIdUsingClient: self client withConfig: self config
]

{ #category : #lifecycle }
EDAAStompTopicListener >> onMessageDo: aBlock [
	self listenerProcess: (self asyncOnMessageDo: aBlock usingClient: self client withConfig: self config).
	^ self listenerProcess
]

{ #category : #initialization }
EDAAStompTopicListener >> resetClient [
	self client: (self buildClientWith: self config)
]

{ #category : #lifecycle }
EDAAStompTopicListener >> subscribe [
	self subscriptionId: self nextId.
	self subscribe: self subscriptionId usingClient: self client withConfig: self config.
	^ self subscriptionId
]

{ #category : #lifecycle }
EDAAStompTopicListener >> subscribe: id usingClient: aClient withConfig: aConfig [
	| subscribeFrame ack |
	aClient open.
	subscribeFrame := StampSubscribeFrame new.
	subscribeFrame destination: aConfig destination.
	subscribeFrame persistent: aConfig durable.
	subscribeFrame id: id.
	subscribeFrame prefetchCount: aConfig prefetchCount.
	ack := aConfig ack.
	(ack = #auto) ifTrue: [ self logErrorMessage: 'ACK is auto. Resetting it to client-individual'. ack := #'client-individual'. ].
	subscribeFrame ack: ack.
	aClient writeWithReceipt: subscribeFrame	
]

{ #category : #accessing }
EDAAStompTopicListener >> subscriptionId [
	^ subscriptionId
]

{ #category : #accessing }
EDAAStompTopicListener >> subscriptionId: val [
	subscriptionId := val
]

{ #category : #enumerating }
EDAAStompTopicListener >> syncOnMessageDo: aBlock usingClient: aClient withConfig: conf [
	[ aClient
		runWith: [ :message | 
			| text |
			text := message body greaseString.
			self class
				logReceivingMessage: message body greaseString
				usingClient: aClient
				from: conf destination.
			[ | ack |
			aBlock value: text.
			ack := conf ack.
			ack = #'client-individual'
				ifFalse: [ self
						logErrorMessage:
							(String
								streamContents: [ :s | 
									s
										nextPutAll: 'ACK was ''';
										nextPutAll: conf ack greaseString;
										nextPutAll: ''' in ';
										nextPutAll: conf class greaseString;
										nextPutAll: '. Resetting it to client-individual.' ]).
					ack := #'client-individual' ].
			ack = #'client-individual'
				ifTrue: [ self logDebugMessage: 'Sending ACK...'.
					aClient writeWithReceipt: message ackFrame.
					self logDebugMessage: 'ACK sent.' ]
				ifFalse: [ self
						logErrorMessage:
							(String
								streamContents: [ :s | 
									s
										nextPutAll: 'Skipping ACK (type is ''';
										nextPutAll: conf ack greaseString;
										nextPut: $' ]) ].
			self class
				logMessageReceived: message body greaseString
				usingClient: aClient
				from: conf destination ]
				on: Error - Break
				do: [ :ex | 
					((ex isKindOf: StampError) and: ex messageText = 'AMQP channel died')
						ifTrue: [ ex signal ].
					self
						logErrorMessage:
							(String
								streamContents: [ :s | 
									s
										nextPutAll: 'Error consuming message: ';
										nextPutAll: ex description greaseString;
										nextPutAll: ' (';
										nextPutAll: thisContext stack last greaseString;
										nextPut: $) ]).
					conf ack = #'client-individual'
						ifTrue: [ | nack |
							self
								logDebugMessage:
									(String
										streamContents: [ :s | 
											s
												nextPutAll: 'Sending NACK message... ';
												nextPutAll: text greaseString;
												nextPut: $. ]).
							nack := message nackFrame.
							nack headers at: 'requeue' put: 'False'.
							aClient writeWithReceipt: nack.
							self
								logDebugMessage:
									(String
										streamContents: [ :s | 
											s
												nextPutAll: 'NACK message sent ';
												nextPutAll: text greaseString;
												nextPut: $. ]) ].
					self
						manageError: ex
						forMessage: text
						usingErrorStrategy: EDACommandConsumingErrorBehavior strategy ] ] ]
		on: PrimitiveFailed , StampError
		do: [ :ex | self logErrorMessage: ex greaseString.
			ex signal ]
]

{ #category : #lifecycle }
EDAAStompTopicListener >> unsubscribe [
	^ self unsubscribe: self subscriptionId usingClient: self client
]

{ #category : #lifecycle }
EDAAStompTopicListener >> unsubscribe: id usingClient: aClient [
	| unsubscribeFrame |
	listenerProcess
		ifNotNil: [ listenerProcess terminate.
			unsubscribeFrame := StampUnsubscribeFrame new id: id.
			aClient isConnected
				ifFalse: [ aClient open ].
			[ aClient writeWithReceipt: unsubscribeFrame ]
				on: Error
					do: [ "ignore this error" ].
			aClient close ]
]
