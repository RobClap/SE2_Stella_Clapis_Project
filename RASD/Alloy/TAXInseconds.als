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
sig nonActiveClient extends Client{}
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

//If a taxi is available and a client is in need the taxi must serve her
fact taxiesServeClientsIfPossible{
	all a:Area | 
	#a.taxis.root.*nextTaxi >= #a.clients.root.*nextClient implies
	no t:AvailableTaxi | t in a.taxis.root.*nextTaxi and #t.serve=0
}

//Clients are served in order
fact ClientsRespectQueuesEvenInItaly{
	no c:ActiveClient | some t:AvailableTaxi | 
	c=t.serve and no t':AvailableTaxi | t'.serve=c.~nextClient 
}

//Taxies are serving in order
fact TaxisServeInOrder{
	no t,t':AvailableTaxi | some c:ActiveClient | 
	t'=t.~nextTaxi and c=t.serve and no c':ActiveClient| c'=t'.serve
}

//Taxies only serve clients in the same area if there are taxies
//available in that clients' area
fact TaxiStayIfNeeded{
	no t:AvailableTaxi | some a:Area | 
	t in a.taxis.root.*nextTaxi and
	#a.taxis.root.*nextTaxi < #a.clients.root.*nextClient and
	t.serve not in a.clients.root.*nextClient
}



//TODO non è corretta, rivederla di modo che un taxi serva in un'
//altra area SE E SOLO SE in quell'area ci sono meno clienti che taxi
/*
fact TaxisDontLeaveAreaIfTheyHaveLocalClients{
	all t:AvailableTaxi | some a:Area | all c:ActiveClient |
	not (c in a.clients.root.*nextClient and
	t in a.taxis.root.*nextTaxi and
	#a.clients.root.*nextClient >= #a.taxis.root.*nextTaxi)
	or
	(#t.serve =1 and
	t.serve in a.clients.root.*nextClient)
}
/*
fact TaxisLeaveAreaIFFNecessary1{
	all c:ActiveClient | some a:Area | all t:AvailableTaxi |
	(c in a.clients.root.*nextClient
	and #a.clients.root.*nextClient < #a.taxis.root.*nextTaxi)
	implies
	(c=t.serve implies t in a.taxis.root.*nextTaxi)
}*/


//OLD:
/*
fact{
	no t:AvailableTaxi | some a:Area | some c:ActiveClient | 
	c=t.serve and t in a.taxis.root.*nextTaxi and 
	c not in a.clients.root.*nextClient
}//*/


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

/*TODO
fun getAreaOfClient[c:ActiveClient]: one Area{
	one a:Area |
	c in a.clients.root.*nextClient
}*/

//ASSERTIONS
//Taxies cross areas only if the client they are serving is in an area without taxies
assert TaxisRespectAreas {
	all t:AvailableTaxi | some ca,ta:Area | some c:ActiveClient | 
	c in ca.clients.root.*nextClient and
	t in ta.taxis.root.*nextTaxi and
	c=t.serve and 
	ca!=ta implies 
	#ca.taxis.root.*nextTaxi = 0
}
//TODO uncomment: check TaxisRespectAreas for 10

assert ActiveClientsMustBeInOneArea {
	all c:ActiveClient | some t:AvailableTaxi | some a:Area | 
	c=t.serve implies c in a.clients.root.*nextClient
}
//TODO uncomment: check ActiveClientsMustBeInOneArea for 10

assert TaxiQueuesAreRespected{
	no t:AvailableTaxi | some t':AvailableTaxi | 
	t' in t.*nextTaxi and
	#t'.serve = 1 and
	#t.serve = 0 
}

//TODO uncomment: check TaxiQueuesAreRespected for 8

assert ClientQueuesAreRespected{
	all c,c':ActiveClient | some t,t':AvailableTaxi | 
	c' in c.*nextClient and
	c' in t.serve implies
	c in t'.serve
}

//check ClientQueuesAreRespected for 10



//PREDICATES
/*
pred OneAreaFewAgents{
	#AvailableTaxi = 2
	#Area = 1
	#ActiveClient = 1
}
run OneAreaFewAgents{} for 4
*/


pred show{}
run show{} for 5 but 2 Area, 2 TaxiQueue, 2 ClientQueue, 0 InactiveTaxi,  0 nonActiveClient, 4 AvailableTaxi, 3 ActiveClient
