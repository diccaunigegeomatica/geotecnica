#!/bin/sh
# UNIGE copyleft
# Author: Roberto Marzocchi

uso_suolo=uso_suolo_2012
#column=DESCR_COD_
column=COD_USO

v.reclass input=$uso_suolo output=uso_suolo_reclass type=boundary column=$column --quiet --overwrite
#aggiungo una nuova colonna al file originario
#v.db.dropcol map=$uso_suolo columns=cod


#GRASS 7
#passare a sqlite
# first rebuild topology for all vector maps in current mapset
#v.build.all
# define new default DB connection (switch from DBF to SQLite)
#db.connect -d
# transfer all attribute tables from DBF to SQLite and clean old DBF tables
#v.db.reconnect.all -cd



v.db.addcolumn map=uso_suolo_reclass columns="new_cat int"
v.db.join map=uso_suolo_2012@liguria_frane column=COD_USO otable=uso_suolo_reclass ocolumn=COD_USO scolumns=new_cat

#v.to.rast 

r.reclass --overwrite input=uso_suolo_reclass output=uso_suolo_6classi rules="/home/roberto/copy/assegno/calcoli/reclass_uso_suolo.txt"
r.mapcalc expression="tmp_frane_stats2=if(isnull(uso_suolo_6classi)&&tmp_frane_stats==1,null(),tmp_frane_stats)" --o
r.stats -c -N input=tmp_frane_stats2,uso_suolo_6classi separator=',' > st_usosuolo_6classi.dat
python statistica_univariata.py -i st_usosuolo_6classi
g.remove rast=tmp_frane_stats2



#GRASS 6.4.2.
#v.db.addcolumn map=$uso_suolo columns="cod int"
#faccio il join fra la nuova tabella e il file originario
#echo "UPDATE $uso_suolo SET cod=(SELECT cat FROM uso_suolo_reclass WHERE $uso_suolo.$column=uso_suolo_reclass.$column);" | db.execute
