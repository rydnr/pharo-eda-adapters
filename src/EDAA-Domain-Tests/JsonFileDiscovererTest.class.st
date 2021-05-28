Class {
	#name : #JsonFileDiscovererTest,
	#superclass : #TestCase,
	#instVars : [
		'tempJsonFile'
	],
	#category : #'EDAA-Domain-Tests'
}

{ #category : #running }
JsonFileDiscovererTest >> setUp [
	super setUp.
	tempJsonFile := File named: ((FileSystem workingDirectory
		/ (self class printString , '.json')) nextVersion)
]

{ #category : #running }
JsonFileDiscovererTest >> tearDown [
	tempJsonFile ifNotNil: [ :f | f name delete ].
	super tearDown
]

{ #category : #tests }
JsonFileDiscovererTest >> testParseAFlatJsonFile [
	| fileContents discoverer |
	fileContents := '{
  "sample": "value"
}'.
	self write: fileContents toFile: tempJsonFile.
	discoverer := JsonFileDiscoverer forJsonFile: tempJsonFile.
	self
		assert: discoverer isNotNil;
		assert: discoverer candidates isNotEmpty;
		assert: discoverer candidates size equals: 1;
		assert: discoverer candidates first isNotNil;
		assert: (discoverer candidates first at: 'sample') equals: 'value'
]

{ #category : #tests }
JsonFileDiscovererTest >> testParseAnEmptyJsonFile [
	| fileContents discoverer |
	fileContents := '{}'.
	self write: fileContents toFile: tempJsonFile.
	discoverer := JsonFileDiscoverer forJsonFile: tempJsonFile.
	self
		assert: discoverer isNotNil;
		assert: discoverer candidates isEmpty
]

{ #category : #tests }
JsonFileDiscovererTest >> testParseAnotherFlatJsonFile [
	| fileContents discoverer |
	fileContents := '{
  "candidate1": "value1",
  "candidate2": "value2"
}'.
	self write: fileContents toFile: tempJsonFile.
	discoverer := JsonFileDiscoverer forJsonFile: tempJsonFile.
	self
		assert: discoverer isNotNil;
		assert: discoverer candidates isNotEmpty;
		assert: discoverer candidates size equals: 2;
		assert: discoverer candidates first isNotNil;
		assert: (discoverer candidates first at: 'candidate1')
			equals: 'value1';
		assert: discoverer candidates second isNotNil;
		assert: (discoverer candidates second at: 'candidate2')
			equals: 'value2'
]

{ #category : #tests }
JsonFileDiscovererTest >> testParseCommandListenerAdapterInJsonFile [
	| fileContents discoverer commandListener |
	fileContents := '{
  "commandListener": {
    "host": "localhost",
    "port": 61613,
    "user": "user",
    "password": "secret",
    "queue": "messages-to-eda",
    "durable": true,
    "ack": "client-individual",
    "prefetchCount": 1,
    "timeout": 60,
    "debug": true,
    "restartOnError": false
  }
}'.
	self write: fileContents toFile: tempJsonFile.
	discoverer := JsonFileDiscoverer forJsonFile: tempJsonFile.
	self
		assert: discoverer isNotNil;
		assert: discoverer candidates isNotEmpty;
		assert: discoverer candidates size equals: 1;
		assert: discoverer candidates first isNotNil.
	commandListener := discoverer candidates first at: 'commandListener'.
	self
		assert: commandListener isNotNil;
		assert: (commandListener at: 'host') equals: 'localhost';
		assert: (commandListener at: 'port') equals: 61613;
		assert: (commandListener at: 'user') equals: 'user';
		assert: (commandListener at: 'password') equals: 'secret';
		assert: (commandListener at: 'queue') equals: 'messages-to-eda';
		assert: (commandListener at: 'durable') equals: true;
		assert: (commandListener at: 'ack') equals: 'client-individual';
		assert: (commandListener at: 'prefetchCount') equals: 1;
		assert: (commandListener at: 'timeout') equals: 60;
		assert: (commandListener at: 'debug') equals: true;
		assert: (commandListener at: 'restartOnError') equals: false
]

{ #category : #helpers }
JsonFileDiscovererTest >> write: aString toFile: aFile [
	aFile name
		writeStreamDo: [ :stream | stream nextPutAll: aString ]
]
