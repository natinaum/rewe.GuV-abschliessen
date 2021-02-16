cat $1 | tail -n +2 | cut -d"," -f1|tr -d '"'|tee soll|tr "\n" "+"|sed "s/+*$/\n/"|bc >> soll
cat $1 | tail -n +2 | cut -d"," -f2|tr -d '"'|tee haben|tr "\n" "+"|sed "s/+*$/\n/"|bc >>haben 

A=`paste soll haben | tail -n 1 | tr "\t" "-"|bc`
cat haben | head -n -1 > habenNeu
cat soll | head -n -1 > sollNeu
if (( $(echo "$A > 0" |bc -l) ));then
	echo SALDO: $A >> habenNeu
	echo >> sollNeu
	cat soll | tail -n 1 >> sollNeu
	cat soll | tail -n 1 >> habenNeu
elif (( $(echo "$A < 0" |bc -l) ));then
	echo SALDO: $A|tr -d "-" >> sollNeu
	echo >> habenNeu
	cat haben | tail -n 1 >> habenNeu
	cat haben | tail -n 1 >> sollNeu
fi

echo '"Soll","Haben"'
paste habenNeu sollNeu |sed "s/\t/\",\"/g"|sed "s/^/\"/g"|sed "s/$/\"/g"
