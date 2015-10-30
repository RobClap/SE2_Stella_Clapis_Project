module TAXInseconds
sig TaxiQueue{root:Taxi}
sig Taxi{next:lone Taxi}

fact nextTaxiNotReflexive { 
	no t:Taxi| t = t.next 
}
fact nextTaxiNotCyclic {
	no t:Taxi | t in t.^next
} 
fact allTaxiesBelongToAtMostOneQueue {
	all t:Taxi | lone q:TaxiQueue | t in q.root.*next
}
fact theRootIsTheRoot{ 
	no t:Taxi | some q:TaxiQueue| some t':Taxi | t=q.root and  t=t'.next
}
fact justOneParent{ 
	
}



//sig ClientQueue{root:Client}
//sig Client{next:lone Client}
//fact nextClientNotReflexive { no c:Client| c = c.next }
//fact nextClientNotCyclic {no c:Client| c in c.^next} 

//fact allClientsBelongToAtMostOneQueue {
//	all c:Client | lone q:ClientQueue | c in q.root.*next
//}

pred show() {}
run show{} for 20
