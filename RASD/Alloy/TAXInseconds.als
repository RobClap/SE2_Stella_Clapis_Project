module TAXInseconds
//TAXIES
abstract sig Taxi{}
sig ActiveTaxi extends Taxi{
	//For the queues
	nextTaxi:lone ActiveTaxi, 
	//For the service
	serve:lone ActiveClient
}
sig InactiveTaxi extends Taxi{}
sig TaxiQueue{root:ActiveTaxi}

//A Taxi can't be his next
fact nextTaxiNotReflexive { 
	no t:ActiveTaxi| t = t.nextTaxi 
}
//A Taxi can't be one of his followers in the queue
fact nextTaxiNotCyclic {
	no t:ActiveTaxi | t in t.^nextTaxi
} 
//If a taxi is active he must be in exactly one queue
fact allActiveTaxiesBelongToOneQueue {
	all t:ActiveTaxi | one q:TaxiQueue | t in q.root.*nextTaxi
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
	no disjoint t,t':ActiveTaxi | t'.serve=t.serve
}

//Clients are served in order
fact ClientsRespectQueuesEvenInItaly{
	no c:ActiveClient | some t:ActiveTaxi | c=t.serve and no t':ActiveTaxi | t'.serve=c.~nextClient 
}

//Taxies are serving in order
fact TaxisServeInOrder{
	no t,t':ActiveTaxi | some c:ActiveClient | t'=t.~nextTaxi and c=t.serve and no c':ActiveClient| c'=t'.serve
}

//Taxies only serve clients in the same area
fact{
	no t:ActiveTaxi | some a:Area | some c:ActiveClient | 
	c=t.serve and t in a.taxis.root.*nextTaxi and c not in a.clients.root.*nextClient
}

//FUNCTIONS
//Get who a taxi is serving
fun getTaxiClient[t:ActiveTaxi]: lone ActiveClient{
	t.serve
}
/*
//Get the area of a ActiveClient
fun getAClientsArea[c:ActiveClient]: one Area{
	a:Area | c in a.clients.root.*next
}
//Get the area of an ActiveTaxi
fun getATaxisArea[t:ActiveTaxi]: one Area{
	a:Area | t in a.taxis.*next
}
*/
//Get who serves a client
fun getClientServer[c:ActiveClient]: lone ActiveTaxi{
	c.~serve
}
//Get Queues for an area
fun getTaxisInArea[a:Area]: set ActiveTaxi{
	a.taxis.root.*nextTaxi
}
fun getActiveClientsInArea[a:Area]: set ActiveClient{
	a.clients.root.*nextClient
}

//TODO
//Get the answer to THE QUESTION
//Understand the whole universe

//PREDICATES
//Make a call
//Add a new taxi?
//Activate a taxi?

//TODO reservations?



pred show{}
run show{} for 5 but 2 Area, 2 TaxiQueue, 2 ClientQueue, 0 InactiveTaxi,  0 nonActiveClient, 6 ActiveTaxi, 6 ActiveClient
