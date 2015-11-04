module TAXInseconds
//TAXIES
abstract sig Taxi{}
sig AvailableTaxi extends Taxi{
	//For the queues
	nextTaxi:lone AvailableTaxi, 
	//For the service
	serve:lone ActiveClient
}
sig InactiveTaxi extends Taxi{
	refused:lone ActiveClient
}
sig TaxiQueue{root:AvailableTaxi}

//A Taxi can't be his next
fact nextTaxiNotReflexive { 
	no t:AvailableTaxi| t = t.nextTaxi 
}
//A Taxi can't be one of his followers in the queue
fact nextTaxiNotCyclic {
	no t:AvailableTaxi | t in t.^nextTaxi
} 
//If a taxi is active he must be in exactly one queue
fact allAvailableTaxiesBelongToOneQueue {
	all t:AvailableTaxi | one q:TaxiQueue | t in q.root.*nextTaxi
}

//Domain Assumption
fact thereIsAtLeastOneFreeTaxi{
	some t:AvailableTaxi | no c:ActiveClient |
	t.serve = c
}

//CLIENTS
abstract sig Client{}
sig ActiveClient extends Client{
	//For the queue
	nextClient:lone ActiveClient
}
sig nonActiveClient extends Client{
	//For reservations
	reserved: lone Area
}
sig ClientQueue{root:ActiveClient}

//A Client can't be his next
fact nextClientNotReflexive { 
	no c:ActiveClient| c= c.nextClient
}
//A Client can't be one of his followers in the queue
fact nextClientNotCyclic {
	no c:ActiveClient| c in c.^nextClient
} 
//If a client is Waiting for a Taxi
//he must be in exactly one queue
fact allActiveClientsBelongToOneQueue {
	all c:ActiveClient| one q:ClientQueue| c in q.root.*nextClient
}

//All clients must have a taxi serving them
fact allClientsAreServed{
	all c:ActiveClient |
	some t:AvailableTaxi |
	c=t.serve
}

//AREAS
sig Area{
	taxis: one TaxiQueue, 
	clients: one ClientQueue
}
fact oneQueueoneArea{
	no c:ClientQueue | some disjoint a,a':Area | 
		c=a.clients  and  c=a'.clients
	no t:TaxiQueue | some disjoint a,a':Area |
		 t=a.taxis  and  t=a'.taxis
}

//All queues must be connected to an Area
fact allQueuesInAreas{
	all c:ClientQueue | some a:Area | c=a.clients
	all t:TaxiQueue | some a:Area | t=a.taxis
}

//INTERACTIONS
//Clients are served only by one taxi
fact noClientsObiquity{
	no disjoint t,t':AvailableTaxi | t'.serve=t.serve
}

//Clients are served in order
fact ClientsRespectQueues{
	no c:ActiveClient | some t:AvailableTaxi | 
	c=t.serve and no t':AvailableTaxi | t'.serve=c.~nextClient
}

//Taxies are serving in order
fact TaxisServeInOrder{
	no t,t':AvailableTaxi | some c:ActiveClient | 
	t'=t.~nextTaxi and c=t.serve and no c':ActiveClient| c'=t'.serve
}

//If an area has more clients than taxies 
//all taxies must be serving
fact TaxiServeIfNeeded{
	no t:AvailableTaxi | some a:Area | 
	t in a.taxis.root.*nextTaxi and
	#a.taxis.root.*nextTaxi <= #a.clients.root.*nextClient 
	and	#t.serve=0 
}

//Serving local clients is preferrable
fact TaxiStayIfNeeded{
	no t:AvailableTaxi | some a:Area | 
	t in a.taxis.root.*nextTaxi and
	#a.taxis.root.*nextTaxi <= #a.clients.root.*nextClient 
	and	t.serve not in a.clients.root.*nextClient 
}

//FUNCTIONS
//Get who a taxi is serving
fun getTaxiClient[t:AvailableTaxi]: lone ActiveClient{
	t.serve
}

//Get who serves a client
fun getClientServer[c:ActiveClient]: lone AvailableTaxi{
	c.~serve
}
//Get Queues for an area
fun getTaxisInArea[a:Area]: set AvailableTaxi{
	a.taxis.root.*nextTaxi
}
fun getActiveClientsInArea[a:Area]: set ActiveClient{
	a.clients.root.*nextClient
}

//ASSERTIONS
//Taxies cross areas only if the client they are serving  
//is in an area without taxies
assert TaxisRespectAreas1 {
	all t:AvailableTaxi | some ca,ta:Area | 
	some c:ActiveClient | 
	c in ca.clients.root.*nextClient and
	t in ta.taxis.root.*nextTaxi and
	c=t.serve and 
	ca!=ta implies 
	#ca.taxis.root.*nextTaxi = 0
}
check TaxisRespectAreas1 for 3

//Taxies cross areas only if the client they are serving  
//is in an area with less taxies than clients
assert TaxisRespectAreas2 {
	all t:AvailableTaxi | some ca,ta:Area | 
	some c:ActiveClient | 
	c in ca.clients.root.*nextClient and
	t in ta.taxis.root.*nextTaxi and
	c=t.serve and 
	ca!=ta implies 
	#ca.taxis.root.*nextTaxi < #ca.clients.root.*nextClient
}

check TaxisRespectAreas2 for 3

assert ActiveClientsMustBeInOneArea {
	all c:ActiveClient | some t:AvailableTaxi | 
	some a:Area | 
	c=t.serve implies c in a.clients.root.*nextClient
}
check ActiveClientsMustBeInOneArea for 3

assert TaxiQueuesAreRespected{
	no t:AvailableTaxi | some t':AvailableTaxi | 
	t' in t.*nextTaxi and
	#t'.serve = 1 and
	#t.serve = 0 
}

check TaxiQueuesAreRespected for 3

assert ClientQueuesAreRespected{
	all c,c':ActiveClient | some t,t':AvailableTaxi | 
	c' in c.*nextClient and
	c' in t.serve implies
	c in t'.serve
}

check ClientQueuesAreRespected for 3

//PREDICATES

pred OneAreaFewAgents{
	#AvailableTaxi = 2
	#Area = 1
	#ActiveClient = 1
}
run OneAreaFewAgents{} for 2 


pred ALotOfTaxis{
	#AvailableTaxi = 5
	#Area = 1
	#ActiveClient=1
}

run ALotOfTaxis{} for 2 

pred TwoAreas{
	#Area=2
}

run TwoAreas{} for 2 but 2 Area

pred show{}
run show{} for 3 but 2 Area,4 ActiveClient,5 AvailableTaxi, 2 TaxiQueue, 
2 ClientQueue, 1 InactiveTaxi, 1 nonActiveClient
