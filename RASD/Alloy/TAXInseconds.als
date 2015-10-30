module TAXInseconds
//TAXIES
abstract sig Taxi{}
sig ActiveTaxi extends Taxi{next:lone ActiveTaxi}
sig InactiveTaxi extends Taxi{}
sig TaxiQueue{root:ActiveTaxi}

fact nextTaxiNotReflexive { 
	no t:ActiveTaxi| t = t.next 
}
fact nextTaxiNotCyclic {
	no t:ActiveTaxi | t in t.^next
} 
fact allActiveTaxiesBelongToOneQueue {
	all t:ActiveTaxi | one q:TaxiQueue | t in q.root.*next
}

//Clients
abstract sig Client{}
sig WaitingClient extends Client{next:lone WaitingClient}
sig nonWaitingClient extends Client{}
sig ClientQueue{root:WaitingClient}

fact nextClientNotReflexive { 
	no c:WaitingClient| c= c.next 
}
fact nextClientNotCyclic {
	no c:WaitingClient| c in c.^next
} 
fact allWaitingClientsBelongToOneQueue {
	all c:WaitingClient| one q:ClientQueue| c in q.root.*next
}

//AREAS
sig Area{taxies: one TaxiQueue, clients: one ClientQueue}
fact oneQueueoneArea{
	no c:ClientQueue | some disjoint a,a':Area | c=a.clients  and  c=a'.clients
	no t:TaxiQueue | some disjoint a,a':Area | t=a.taxies  and  t=a'.taxies
}

fact allQueuesInAreas{
	all c:ClientQueue | some a:Area | c=a.clients
	all t:TaxiQueue | some a:Area | t=a.taxies
}

pred show{}
run show{} for 10 but 2 Area, 2 TaxiQueue, 2 ClientQueue, 1 InactiveTaxi,  1 nonWaitingClient, 6 ActiveTaxi, 4 WaitingClient
