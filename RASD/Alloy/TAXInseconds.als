module TAXInseconds
//TAXIES
abstract sig Taxi{}
sig AvailableTaxi extends Taxi{
	//For the queues
	nextTaxi:lone AvailableTaxi, 
	//For the service
	serve:lone ActiveClient
}
sig InactiveTaxi extends Taxi{}
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
//If a client is Waiting for a Taxi, he must be in exactly one queue
fact allActiveClientsBelongToOneQueue {
	all c:ActiveClient| one q:ClientQueue| c in q.root.*nextClient
}

//AREAS
sig Area{
	taxis: one TaxiQueue, 
	clients: one ClientQueue
}
fact oneQueueoneArea{
	no c:ClientQueue | some disjoint a,a':Area | c=a.clients  and  c=a'.clients
	no t:TaxiQueue | some disjoint a,a':Area | t=a.taxis  and  t=a'.taxis
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
fact ClientsRespectQueuesEvenInItaly{
	no c:ActiveClient | some t:AvailableTaxi | c=t.serve and no t':AvailableTaxi | t'.serve=c.~nextClient 
}

//Taxies are serving in order
fact TaxisServeInOrder{
	no t,t':AvailableTaxi | some c:ActiveClient | t'=t.~nextTaxi and c=t.serve and no c':ActiveClient| c'=t'.serve
}

//Taxies only serve clients in the same area
fact{
	no t:AvailableTaxi | some a:Area | some c:ActiveClient | 
	c=t.serve and t in a.taxis.root.*nextTaxi and c not in a.clients.root.*nextClient
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
//hm, what?

//PREDICATES
//Just show stuff in different ways
//Make a call
//Add a new taxi?
//Activate a taxi?

//TODO reservations?
//TODO database?


pred show{}
run show{} for 5 but 2 Area, 2 TaxiQueue, 2 ClientQueue, 0 InactiveTaxi,  0 nonActiveClient, 6 AvailableTaxi, 6 ActiveClient
