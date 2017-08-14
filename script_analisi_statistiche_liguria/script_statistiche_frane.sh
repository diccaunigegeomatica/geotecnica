#!/bin/sh
# UNIGE copyleft
# Author: Roberto Marzocchi


#################################
#dati iniziali
#################################
dem_iniziale=dem20_liguria
frane=frane_superficiali_colamenti_rapidi
litologia=litologia_liguria



echo "\n\n****************\n region \n****************"
g.region -p rast=$dem_iniziale

echo "\n\n****************\n slope \n****************"
r.slope.aspect elevation=$dem_iniziale slope=tmp_slope aspect=tmp_aspect --overwrite --quiet


#################################
#creo le classi di aspect
#################################
r.mapcalc "aspect_classi=if($dem_iniziale==0,null(),if(tmp_aspect>=0&&tmp_aspect<45,1,if(tmp_aspect>=45&&tmp_aspect<90,2,if(tmp_aspect>=90&&tmp_aspect<135,3,if(tmp_aspect>=135&&tmp_aspect<180,4,if(tmp_aspect>=180&&tmp_aspect<225,5,if(tmp_aspect>=225&&tmp_aspect<270,6,if(tmp_aspect>=270&&tmp_aspect<315,7,if(tmp_aspect>=315&&tmp_aspect<=360,8)))))))))"


#################################
#creo le classi di pendenze
#################################
# 9 classi (2 referenze)
r.mapcalc "slope_classi=if($dem_iniziale==0,null(),if(tmp_slope>=0&&tmp_slope<5,1,if(tmp_slope>=5&&tmp_slope<10,2,if(tmp_slope>=10&&tmp_slope<15,3,if(tmp_slope>=15&&tmp_slope<20,4,if(tmp_slope>=20&&tmp_slope<25,5,if(tmp_slope>=25&&tmp_slope<30,6,if(tmp_slope>=30&&tmp_slope<35,7,if(tmp_slope>=35&&tmp_slope<40,8,if(tmp_slope>=40,9))))))))))"


#################################
#creo le classi di quota
#################################
r.mapcalc "classi_quota_100=if($dem_iniziale==0,null(),int($dem_iniziale/100+1))"



#################################
#creo la mappa delle frane
#################################
v.to.rast input=$frane type=area output=tmp_frane use=cat
r.mapcalc "tmp_frane_stats=if($dem_iniziale==0,null(),tmp_frane/tmp_frane)"


echo "\n\n****************\n STATISTICHE \n****************"
#esempio di statistica
r.stats -c -N input=tmp_frane_stats,aspect_classi fs=',' > st_aspect.dat
python statistica_univariata.py -i st_aspect


r.stats -c -N input=tmp_frane_stats,slope_classi fs=',' > st_slope.dat
python statistica_univariata.py -i st_slope


r.stats -c -N input=tmp_frane_stats,classi_quota_100 fs=',' > st_quote.dat
python statistica_univariata.py -i st_quote

#################################
#ACCUMULAZIONE
################################
r.watershed elevation=$dem_iniziale accumulation=accumulazione
r.mapcalc "accumulazione_classi=if($dem_iniziale==0,null(),if(accumulazione>=0&&accumulazione<=1,1,if(accumulazione>1&&accumulazione<=3,2,if(accumulazione>3&&accumulazione<=20,3,if(accumulazione>20&&accumulazione<=4,50,if(accumulazione>50&&accumulazione<=1000,5,if(accumulazione>1000,6)))))))"

r.stats -c -N input=tmp_frane_stats,accumulazione_classi fs=',' > st_accumulazione.dat
python statistica_univariata.py -i st_accumulazione


#################################
# rete drenaggio
################################
r.mapcalc "inf_fiumi=if(log(abs(accumulazione)+1)>6)"
r.buffer input=inf_fiumi output=buf_fiumi distances=20,40,60,80,100 --quiet --overwrite
r.mapcalc "buf_fiumi=if(isnull(buf_fiumi),0,if($dem_iniziale==0,null(),buf_fiumi))"
r.stats -c -N input=tmp_frane_stats,buf_fiumi fs=',' > st_reticolo.dat
python statistica_univariata.py -i st_reticolo


#################################
# geologia
################################
#db.connect driver=sqlite database='$GISDBASE/$LOCATION_NAME/$MAPSET/sqlite.db'
#db.connect driver=dbf database='$GISDBASE/$LOCATION_NAME/$MAPSET/dbf'

# questo settore e' specifico per la litologia ligure
v.reclass input=$litologia output=litologia_reclass type=boundary column=DESC_25000 --quiet --overwrite
#aggiungo una nuova colonna al file originario
#v.db.dropcol map=$litologia columns=cod
v.db.addcol map=$litologia columns="cod int"
#faccio il join fra la nuova tabella e il file originario
echo "UPDATE $litologia SET cod=(SELECT cat FROM litologia_reclass WHERE $litologia.DESC_25000=litologia_reclass.DESC_25000);" | db.execute


v.to.rast --overwrite --quiet input=$litologia type=area output=litologia_reclass column=cod labelcolumn=DESC_25000
r.mapcalc "tmp_frane_stats2=if(isnull(litologia_reclass)&&tmp_frane_stats==1,null(),tmp_frane_stats)"
r.stats -c -N input=tmp_frane_stats2,litologia_reclass fs=',' > st_litologia.dat
python statistica_univariata.py -i st_litologia
g.remove rast=tmp_frane_stats2




uso_suolo=uso_suolo_2012
column=DESCR_COD_

v.reclass input=$uso_suolo output=uso_suolo_reclass type=boundary column=$column --quiet --overwrite
#aggiungo una nuova colonna al file originario
#v.db.dropcol map=$uso_suolo columns=cod
v.db.addcol map=$uso_suolo columns="cod int"
#faccio il join fra la nuova tabella e il file originario
echo "UPDATE $uso_suolo SET cod=(SELECT cat FROM uso_suolo_reclass WHERE $uso_suolo.$column=uso_suolo_reclass.$column);" | db.execute


v.to.rast --overwrite --quiet input=$uso_suolo type=area output=uso_suolo_reclass column=cod labelcolumn=$column
r.mapcalc "tmp_frane_stats2=if(isnull(uso_suolo_reclass)&&tmp_frane_stats==1,null(),tmp_frane_stats)"
r.stats -c -N input=tmp_frane_stats2,uso_suolo_reclass fs=',' > st_usosuolo.dat
python statistica_univariata.py -i st_usosuolo
g.remove rast=tmp_frane_stats2



#################################
# strade
################################

strade=strade_sede_propria

v.to.rast input=$strade type=line output=strade use=cat
r.mapcalc "strade=strade/strade"
r.buffer input=strade output=buf_strade distances=50,100,200 --quiet --overwrite
r.mapcalc "buf_strade=if(isnull(buf_strade),0,if($dem_iniziale==0,null(),buf_strade))"
r.stats -c -N input=tmp_frane_stats,buf_strade fs=',' > st_strade.dat
python statistica_univariata.py -i st_strade


#################################
# aggressivita' climatica
################################

#grass7

r.mapcalc expression="tmp_frane_stats2=if(isnull(AC_classi)&&tmp_frane_stats==1,null(),tmp_frane_stats)" --o
r.stats -c -N input=tmp_frane_stats,AC_classi separator=',' > st_AC.dat
python statistica_univariata.py -i st_AC


