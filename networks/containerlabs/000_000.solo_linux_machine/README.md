# Configure a single alpine linux machine to be used as a test platform for reverse bushrangers. 

Goals

* create external endpoint that can be used by bushranger to ssh into
* bushranger will route to 10.13.HOST.0/24 via gateway 10.13.37.HOST
* alpine server must have an address in 10.13.HOST.0/24 network
