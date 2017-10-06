#!/bin/sh

v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/frane/frane/pol_full/pol_full.shp layer=pol_full output=pol_full
g.region vector=pol_full
g.region res=20
v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/frane/frane/pol_sup_NO_translational/pol_sup_NO_translational.shp layer=pol_sup_NO_translational output=pol_sup_NO_translational
v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/Aree_validazione/scivolamenti/aree_validaz1_scivolamenti.shp layer=aree_validaz1_scivolamenti output=scivolamenti

v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/frane/frane/lin_full/lin_full.shp layer=lin_full output=lin_full
r.in.gdal input=/media/sf_Tesi/Dati/Piemonte/DEM_5m/Cuneo_20m.tif output=dem

v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/Cuneo/Cuneo.shp layer=Cuneo output=Cuneo




dem_iniziale=dem #raster
frane=frane_considerate #vettore contenente le frane che decido di prendere in esame
regione=Cuneo #Vettore che delimita l'area di studio
litologia=litologia_regione #vettore contenente la litologia
g.region raster=dem
#g.region res=20
#g.region -p

#r.mask vector=$regione
#r.mapcalc --overwrite "Cuneo=dem"
#g.remove -f type=raster name=dem
#r.mask -r

#g.region raster=Cuneo

#################################
#creo la mappa delle frane
#################################
g.region res=5
v.overlay --overwrite ainput=pol_sup_NO_translational binput=pol_full operator=or output=pol_sup_full
v.overlay --overwrite ainput=scivolamenti binput=pol_sup_full operator=or output=scivolamenti_pol_sup_full
scivolamenti_pol_sup_full=frane_aree
lin_full=frane_linari
v.overlay ainput=$regione binput=scivolamenti_pol_sup_full operator=and output=tmp_frane_aree 
v.overlay ainput=lin_full binput=$regione operator=and output=tmp_frane_lineari 
v.to.rast input=tmp_frane_aree output=tmp_frane_aree use=cat
v.to.rast input=tmp_frane_lineari output=tmp_frane_lineari use=cat
r.patch input=tmp_frane_lineari,tmp_frane_aree output=tmp_frane

r.null map=tmp_frane null=0
r.mapcalc "Area_calibrazione  = if( isnull($dem_iniziale ), null() , if( tmp_frane >0, 1, 0 )  )"
#r.mapcalc --overwrite expression="tmp_frane_stats=if($dem_iniziale==0,null(),tmp_frane/tmp_frane)"
v.to.rast input=$regione output=cuneo use=cat
r.colors map=Area_calibrazione color=bcyr

#r.mapcalc expression="if(isnull($dem_iniziale), null(), if($frane_considerate > 0,1, 0))"
g.region res=20

##################################
#creo aree verifica
##################################
v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/Aree_validazione/complesse/aree_validaz2_complesse.shp layer=aree_validaz2_complesse output=aree_validaz2_complesse
v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/Aree_validazione/incipient_slide/aree_validaz3_incipient_slide.shp layer=aree_validaz3_incipient_slide output=aree_validaz3_incipient_slide
v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/Aree_validazione/indizi_instab/aree_validaz4_indizi_instab.shp layer=aree_validaz4_indizi_instab output=aree_validaz4_indizi_instab
v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/Aree_validazione/indeterminate/aree_validaz5_indet.shp layer=aree_validaz5_indet output=aree_validaz5_indet
v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/frane/scivolamenti_incipienti.shp layer=scivolamenti_incipienti output=scivolamenti_incipienti

g.region res=5
v.overlay ainput=$regione binput=aree_validaz2_complesse operator=and output=tmp_frane_complesse
v.to.rast input=tmp_frane_complesse output=tmp_frane_complesse use=attr attribute_column=cat
r.null map=tmp_frane_complesse null=0
r.mapcalc "Area_verifica_complesse  = if( isnull($dem_iniziale ), null() , if( tmp_frane_complesse >0, 1, 0 )  )"
r.colors map=Area_verifica_complesse color=bcyr

v.overlay ainput=$regione binput=aree_validaz3_incipient_slide operator=and output=tmp_frane_incipient_slide
v.to.rast input=tmp_frane_incipient_slide output=tmp_frane_incipient_slide use=attr attribute_column=cat
r.null map=tmp_frane_incipient_slide null=0
r.mapcalc "Area_verifica_incipient_slide  = if( isnull($dem_iniziale ), null() , if( tmp_frane_incipient_slide >0, 1, 0 )  )"
r.colors map=Area_verifica_incipient_slide color=bcyr

v.overlay ainput=$regione binput=aree_validaz4_indizi_instab operator=and output=tmp_frane_indizi_instab
v.to.rast input=tmp_frane_indizi_instab output=tmp_frane_indizi_instab use=attr attribute_column=cat
r.null map=tmp_frane_indizi_instab null=0
r.mapcalc "Area_verifica_indizi_instab  = if( isnull($dem_iniziale ), null() , if( tmp_frane_indizi_instab >0, 1, 0 )  )"
r.colors map=Area_verifica_indizi_instab color=bcyr

v.overlay ainput=$regione binput=aree_validaz5_indet operator=and output=tmp_frane_indet
v.to.rast input=tmp_frane_indet output=tmp_frane_indet use=attr attribute_column=cat
r.null map=tmp_frane_indet null=0
r.mapcalc "Area_verifica_indet  = if( isnull($dem_iniziale ), null() , if( tmp_frane_indet >0, 1, 0 )  )"
r.colors map=Area_verifica_indet color=bcyr

v.overlay ainput=$regione binput=scivolamenti_incipienti operator=and output=tmp_scivolamenti_incipienti
v.to.rast input=tmp_scivolamenti_incipienti output=tmp_scivolamenti_incipienti use=attr attribute_column=cat
r.null map=tmp_scivolamenti_incipienti null=0
r.mapcalc "Area_verifica_scivolamenti_incipienti  = if( isnull($dem_iniziale ), null() , if( tmp_scivolamenti_incipienti >0, 1, 0 )  )"
r.colors map=Area_verifica_indet color=bcyr

g.region res=20

##############################
#creo mappa pendenze e aspect
##############################

r.slope.aspect elevation=$dem_iniziale slope=tmp_slope aspect=tmp_aspect --overwrite --quiet

##############################
#creo le classi di aspect
##############################

r.mapcalc expression="aspect_classi=if($dem_iniziale==0,null(),if(tmp_aspect>=0&&tmp_aspect<45,1,if(tmp_aspect>=45&&tmp_aspect<90,2,if(tmp_aspect>=90&&tmp_aspect<135,3,if(tmp_aspect>=135&&tmp_aspect<180,4,if(tmp_aspect>=180&&tmp_aspect<225,5,if(tmp_aspect>=225&&tmp_aspect<270,6,if(tmp_aspect>=270&&tmp_aspect<315,7,if(tmp_aspect>=315&&tmp_aspect<=360,8)))))))))"
#r.mapcalc --overwrite expression="aspect_4classi_mapcalc=if(tmp_aspect>=0&&tmp_aspect<90,1,if(tmp_aspect>=90&&tmp_aspect<180,2,if(tmp_aspect>=180&&tmp_aspect<270,3,if(tmp_aspect>=270&&tmp_aspect<=360,4))))"
#r.mapcalc --overwrite expression="aspect_2classi_mapcalc=if(tmp_aspect>=0&&tmp_aspect<180,1,if(tmp_aspect>=180&&tmp_aspect<=360,2,))"

r.reclass input=tmp_aspect output=aspect_2classi rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/reclass_esposizione_2classi..txt"
r.reclass --overwrite input=tmp_aspect output=aspect_2classi_crescente rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_esposizione_2classi.txt"

r.reclass input=tmp_aspect output=aspect_4classi rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/reclass_esposizione_4classi..txt"
r.reclass --overwrite input=aspect_4classi output=aspect_4classi_crescente rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/Piemonte_reclass_esposizione_4classi_crescente.txt"
r.reclass --overwrite input=tmp_aspect output=aspect_4classi_crescente_scaletta rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_esposizione_scaletta.txt"

r.reclass input=tmp_aspect output=aspect_4classi_B rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_esposizione_4classi_B.txt"
r.reclass input=aspect_4classi_B output=aspect_4classi_B_crescente rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_esposizione_4classi_B_crescente.txt"

r.reclass input=tmp_aspect output=aspect_4classi_C rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_esposizione_4classi_C.txt"


##############################
#creo le classi di pendenze
##############################

# 9 classi 
r.mapcalc --overwrite expression="slope_classi=if($dem_iniziale==0,null(),if(tmp_slope>=0&&tmp_slope<5,1,if(tmp_slope>=5&&tmp_slope<10,2,if(tmp_slope>=10&&tmp_slope<15,3,if(tmp_slope>=15&&tmp_slope<20,4,if(tmp_slope>=20&&tmp_slope<25,5,if(tmp_slope>=25&&tmp_slope<30,6,if(tmp_slope>=30&&tmp_slope<35,7,if(tmp_slope>=35&&tmp_slope<40,8,if(tmp_slope>=40,9))))))))))"

# 5 classi 
r.mapcalc --overwrite expression="slope_5classi=if($dem_iniziale==0,null(),if(tmp_slope>=0&&tmp_slope<5,1,if(tmp_slope>=5&&tmp_slope<10,2,if(tmp_slope>=10&&tmp_slope<15,3,if(tmp_slope>=15&&tmp_slope<20,4,if(tmp_slope>=20,5))))))"
#r.reclass --overwrite input=slope_classi output=slope_classi_crescente rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_pendenza_crescente.txt"

# 3 classi 
r.mapcalc --overwrite expression="slope_3classi=if($dem_iniziale==0,null(),if(tmp_slope>=0&&tmp_slope<5,1,if(tmp_slope>=5&&tmp_slope<10,2,if(tmp_slope>=10,3))))"

#13 classi

#r.mapcalc --overwrite expression="slope_13classi=if($dem_iniziale==0,null(),if(tmp_slope>=0&&tmp_slope<5,1,if(tmp_slope>=5&&tmp_slope<10,2,if(tmp_slope>=10&&tmp_slope<15,3,if(tmp_slope>=15&&tmp_slope<20,4,if(tmp_slope>=20&&tmp_slope<25,5,if(tmp_slope>=25&&tmp_slope<30,6,if(tmp_slope>=30&&tmp_slope<35,7,if(tmp_slope>=35&&tmp_slope<40,8,if(tmp_slope>=40&&tmp_slope<45,9,if(tmp_slope>=45&&tmp_slope<50,10,if(tmp_slope>=50&&tmp_slope<55,11,if(tmp_slope>=55&&tmp_slope<60,12,if(tmp_slope>=60,13))))))))))))))"
#r.stats -c -n input=Area_calibrazione,slope_13classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_slope_13classi.txt separator=comma

#Param.scale
r.param.scale input=$dem_iniziale output=slope_param_scale size=9 method=slope
r.mapcalc --overwrite expression="slope_param_scale_classi=if($dem_iniziale==0,null(),if(slope_param_scale>=0&&slope_param_scale<5,1,if(slope_param_scale>=5&&slope_param_scale<10,2,if(slope_param_scale>=10&&slope_param_scale<15,3,if(slope_param_scale>=15&&slope_param_scale<20,4,if(slope_param_scale>=20&&slope_param_scale<25,5,if(slope_param_scale>=25&&slope_param_scale<30,6,if(slope_param_scale>=30&&slope_param_scale<35,7,if(slope_param_scale>=35&&slope_param_scale<40,8,if(slope_param_scale>=40,9))))))))))"
r.param.scale input=$dem_iniziale output=morfologia size=9 method=feature
r.mapcalc --overwrite expression="slope_param_scale_4classi=if($dem_iniziale==0,null(),if(slope_param_scale>=0&&slope_param_scale<5,1,if(slope_param_scale>=5&&slope_param_scale<10,2,if(slope_param_scale>=10&&slope_param_scale<15,3,if(slope_param_scale>=15,4)))))"
r.mapcalc --overwrite expression="slope_param_scale_3classi=if($dem_iniziale==0,null(),if(slope_param_scale>=0&&slope_param_scale<5,1,if(slope_param_scale>=5&&slope_param_scale<10,2,if(slope_param_scale>=10,3))))"

r.reclass --overwrite input=morfologia output=classi_morfologia_crescente rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/Cuneo_reclass_morfologia.txt





#################################
#creo le classi di quota
#################################

g.region raster=$dem_iniziale
g.region -p
r.mapcalc --overwrite expression="classi_quota_250=if($dem_iniziale==0,null(),int($dem_iniziale/250+1))"


#################################
#ACCUMULAZIONE - Dimensione minima bacini 1km2 = 1000000 m2 = 5x5x2500
################################
r.fill.dir --overwrite input=$dem_iniziale output=cuneo_depressionless direction=cuneo_flow_direction
r.watershed --overwrite elevation=cuneo_depressionless threshold=2500 accumulation=accumulazione
r.mapcalc --overwrite expression="log_accumulazione = log(abs( accumulazione) + 1)"
r.mapcalc --overwrite expression="log_accumulazione_interi = int( log_accumulazione )"
r.reclass --overwrite input=log_accumulazione_interi output=classi_accumulazione rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/reclass_accumulazione..txt
r.stats -c -n --overwrite input=Area_calibrazione,classi_accumulazione output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_accumulazione.txt separator=comma




#################################
# litologia
################################

g.copy raster=classi_litologia@Dati_Piemonte,classi_litologia

#v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/Litologia/litologia.shp layer=litologia output=litologia
#v.db.reconnect.all old_database='$GISDBASE/$LOCATION_NAME/$MAPSET/dbf/'new_driver=sqlite new_database='$GISDBASE/$LOCATION_NAME/$MAPSET/sqlite/sqlite.db'
#v.reclass input=litologia output=litologia_reclass type=boundary column=classe --quiet --overwrite
#v.db.addcolumn map=litologia columns="cod int"
#db.execute sql="UPDATE litologia SET cod=(SELECT cat FROM litologia_reclass WHERE litologia.classe=litologia_reclass.classe)"
#v.to.rast input=litologia type=area output=litologia_reclass use=attr attribute_column=cod label_column=desc_unlit

#r.mask raster=$dem_iniziale
#r.mapcalc "litologia_reclass = litologia_reclass" --overwrite
#r.mask -r

#r.reclass input=litologia_reclass output=classi_litologia rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/Piemonte_reclass_litologia.txt
r.reclass input=classi_litologia output=classi_litologia_crescente rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/Piemonte_reclass_litologia_crescente.txt


#################################
# uso_suolo
################################

g.copy raster=classi_uso_suolo@Dati_Piemonte,classi_uso_suolo

#r.in.gdal input=/media/sf_Tesi/Dati/Piemonte/uso_suolo/uso_suolo.tif output=uso_suolo
#r.in.gdal input=/media/sf_Tesi/Dati/Piemonte/Landcover/lcp_v03_2010_clip.tif output=uso_suolo
#r.mask raster=$dem_iniziale
#r.mapcalc "uso_suolo = uso_suolo" --overwrite
#r.mask -r

r.reclass --overwrite input=classi_uso_suolo output=classi_uso_suolo rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/Piemonte_reclass_uso_suolo.txt
r.reclass --overwrite input=classi_uso_suolo output=classi_uso_suolo_crescente rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/Piemonte_reclass_uso_suolo_crescente.txt

#################################
# strade
################################

g.copy raster=buf_strade@Dati_Piemonte,buf_strade

#v.in.ogr input=/media/sf_Tesi/Dati/Piemonte/tratte_stradali/strade/tratte_stradali_Piemonte.shp layer=tratte_stradali_Piemonte output=tratte_stradali
#v.overlay ainput=tratte_stradali binput=$regione operator=and output=strade 
#v.to.rast input=strade type=line output=strade use=cat
#r.buffer input=strade output=buf_strade distances=50,100,150,200,100000

#g.region raster=$dem_iniziale
#r.mask vector=$regione
#r.mapcalc "buf_strade = buf_strade" --overwrite
#r.mask -r

#r.reclass input=buf_strade output=buf_strade_crescente rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_distanza_strade.txt
r.stats --overwrite -c -n input=Area_calibrazione,buf_strade output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_strade.txt separator=comma
#r.stats --overwrite -c -n input=Area_calibrazione,buf_strade_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_strade_crescente.txt separator=comma

#################################
# aggressivita' climatica
################################
r.in.gdal input=/media/sf_Tesi/Dati/Liguria/AC_meteoswiss output=AC_meteoswiss

g.region raster=$dem_iniziale
r.mask vector=$regione
r.mapcalc "aggressivita_climatica = AC_meteoswiss" --overwrite
r.mask -r

aggressivita_climatica=AC


r.reclass input=aggressivita_climatica output=AC_7classi rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/Piemonte_reclass_AC.txt
r.reclass input=aggressivita_climatica output=AC_5classi rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/Piemonte_reclass_AC_5classi.txt
r.reclass input=aggressivita_climatica output=AC_3classi rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/Piemonte_reclass_AC_3classi.txt


r.stats -c -n input=Area_calibrazione,AC_5classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_AC_5classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,AC_7classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_AC_7classi.txt separator=comma

r.stats -c -n input=Area_calibrazione,classi_uso_suolo output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_uso_suolo.txt separator=comma
r.stats -c -n input=Area_calibrazione,classi_uso_suolo_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_uso_suolo_crescente.txt separator=comma


#r.stats -c -n input=Area_calibrazione,AC_6classi_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_AC_6classi_crescente.txt separator=comma
#r.stats -c -n input=Area_calibrazione,AC_6classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_AC_6classi.txt separator=comma
#r.stats -c -n input=Area_calibrazione,AC_4classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_AC_4classi.txt separator=comma
#r.stats -c -n input=Area_calibrazione,AC_2classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_AC_2classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,AC_3classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_AC_3classi.txt separator=comma


r.stats -c -n input=Area_calibrazione,aspect_classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_aspect_8classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_4classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_aspect_4classi.txt separator=comma
#r.stats -c -n input=Area_calibrazione,aspect_4classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_aspect_4classi.txt separator=comma
#r.stats -c -n input=Area_calibrazione,aspect_4classi_mapcalc output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_aspect_4classi_mapcalc.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_2classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_aspect_2classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_4classi_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_aspect_4classi_crescente.txt separator=comma
#r.stats -c -n input=Area_calibrazione,aspect_2classi_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_aspect_2classi_crescente.txt separator=comma
#r.stats -c -n input=Area_calibrazione,aspect_4classi_crescente_scaletta output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_aspect_4classi_crescente_scaletta.txt separator=comma
#r.stats -c -n input=Area_calibrazione,aspect_4classi_B output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_aspect_4classi_B.txt separator=comma
#r.stats -c -n input=Area_calibrazione,aspect_4classi_B_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_aspect_4classi_B_crescente.txt separator=comma
#r.stats -c -n input=Area_calibrazione,aspect_4classi_C output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_aspect_4classi_C.txt separator=comma



r.stats -c -n input=Area_calibrazione,slope_classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_slope_9classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,slope_5classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_slope_5classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,slope_3classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_slope_3classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,morfologia output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_morfologia.txt separator=comma
r.stats -c -n input=Area_calibrazione,classi_morfologia_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_morfologia_crescente.txt separator=comma



r.stats -c -n input=Area_calibrazione,slope_param_scale_3classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_slope_param_scale_3classi.txt separator=comma


r.stats -c -n input=Area_calibrazione,classi_quota_250 output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_quota_250.txt separator=comma


r.stats -c -n input=Area_calibrazione,classi_litologia output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_litologia.txt separator=comma
r.stats -c -n input=Area_calibrazione,classi_litologia_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_classi_litologia_crescente.txt separator=comma


#r.stats -c -n input=Area_calibrazione,litologia_reclass output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Analisi_univariata/Cuneo/stats_litologia_reclass_28.txt separator=comma


exit 0

