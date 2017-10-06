#!/bin/sh
# script per analisi univariata generale, servono dem_iniziale, frane considerate, litologia, tratte stradali ecc. Li importo e posso usare lo script.

g.copy raster=Imperia_5m@Lorenzo_IMPERIA,Imperia_5m
g.copy vector=frane_superficiali_colamenti_rapidi_lenti_scivolamenti_imperia@Lorenzo_IMPERIA,frane_considerate
g.copy vector=Imperia@Lorenzo_IMPERIA,Imperia
r.in.gdal input=/media/sf_Tesi/Dati/dem_90_senza_buchi output=dem_90_senza_buchi
r.in.gdal input=/media/sf_Tesi/Dati/AC_meteoswiss output=AC_meteoswiss

dem_iniziale=Imperia_5m #raster
frane=frane_considerate #vettore contenente le frane che decido di prendere in esame
regione=Imperia #Vettore che delimita l'area di studio
litologia=litologia_regione #vettore contenente la litologia
dem90=dem_90_senza_buchi
g.region raster=$dem_iniziale
g.region -p


#################################
#creo la mappa delle frane
#################################
v.overlay ainput=$regione binput=$frane operator=and output=tmp_frane
v.to.rast input=frane_considerate output=tmp_frane use=attr attribute_column=cat
r.null map=tmp_frane null=0
r.mapcalc "Area_calibrazione  = if( isnull($dem_iniziale ), null() , if( tmp_frane >0, 1, 0 )  )"
#r.mapcalc --overwrite expression="tmp_frane_stats=if($dem_iniziale==0,null(),tmp_frane/tmp_frane)"
v.to.rast input=$regione output=imperia use=cat
r.colors map=Area_calibrazione color=bcyr


#r.mapcalc expression="if(isnull($dem_iniziale), null(), if($frane_considerate > 0,1, 0))"


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
r.reclass --overwrite input=tmp_aspect output=aspect_4classi_crescente rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_esposizione_4classi.txt"
r.reclass --overwrite input=tmp_aspect output=aspect_4classi_crescente_scaletta rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_esposizione_scaletta.txt"

r.reclass input=tmp_aspect output=aspect_4classi_B rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_esposizione_4classi_B.txt"
r.reclass input=aspect_4classi_B output=aspect_4classi_B_crescente rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_esposizione_4classi_B_crescente.txt"

r.reclass input=tmp_aspect output=aspect_4classi_C rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_esposizione_4classi_C.txt"


##############################
#creo le classi di pendenze
##############################

# 9 classi 
r.mapcalc --overwrite expression="slope_classi=if($dem_iniziale==0,null(),if(tmp_slope>=0&&tmp_slope<5,1,if(tmp_slope>=5&&tmp_slope<10,2,if(tmp_slope>=10&&tmp_slope<15,3,if(tmp_slope>=15&&tmp_slope<20,4,if(tmp_slope>=20&&tmp_slope<25,5,if(tmp_slope>=25&&tmp_slope<30,6,if(tmp_slope>=30&&tmp_slope<35,7,if(tmp_slope>=35&&tmp_slope<40,8,if(tmp_slope>=40,9))))))))))"
#r.reclass --overwrite input=slope_classi output=slope_classi_crescente rules="/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_pendenza_crescente.txt"

#13 classi

#r.mapcalc --overwrite expression="slope_13classi=if($dem_iniziale==0,null(),if(tmp_slope>=0&&tmp_slope<5,1,if(tmp_slope>=5&&tmp_slope<10,2,if(tmp_slope>=10&&tmp_slope<15,3,if(tmp_slope>=15&&tmp_slope<20,4,if(tmp_slope>=20&&tmp_slope<25,5,if(tmp_slope>=25&&tmp_slope<30,6,if(tmp_slope>=30&&tmp_slope<35,7,if(tmp_slope>=35&&tmp_slope<40,8,if(tmp_slope>=40&&tmp_slope<45,9,if(tmp_slope>=45&&tmp_slope<50,10,if(tmp_slope>=50&&tmp_slope<55,11,if(tmp_slope>=55&&tmp_slope<60,12,if(tmp_slope>=60,13))))))))))))))"
#r.stats -c -n input=Area_calibrazione,slope_13classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_slope_13classi.txt separator=comma

#Param.scale
#r.param.scale input=$dem_iniziale output=slope_param_scale size=9 method=slope
#r.mapcalc --overwrite expression="slope_param_scale_classi=if($dem_iniziale==0,null(),if(slope_param_scale>=0&&slope_param_scale<5,1,if(slope_param_scale>=5&&slope_param_scale<10,2,if(slope_param_scale>=10&&slope_param_scale<15,3,if(slope_param_scale>=15&&slope_param_scale<20,4,if(slope_param_scale>=20&&slope_param_scale<25,5,if(slope_param_scale>=25&&slope_param_scale<30,6,if(slope_param_scale>=30&&slope_param_scale<35,7,if(slope_param_scale>=35&&slope_param_scale<40,8,if(slope_param_scale>=40,9))))))))))"
#r.param.scale input=$dem_iniziale output=morfologia size=9 method=feature


#############################Creo pendenza da dem a 20m#############################

g.region res=20
g.copy raster=dem20m_liguria@rovegno_frane_liguria,dem20_liguria
r.mask vector=$regione
r.mapcalc --overwrite "Imperia_20m=dem20_liguria"
g.remove -f type=raster name=dem20_liguria
r.mask -r

r.slope.aspect elevation=Imperia_20m slope=tmp_slope_20m --overwrite
r.mapcalc --overwrite expression="slope_classi_20m=if($dem_iniziale==0,null(),if(tmp_slope_20m>=0&&tmp_slope_20m<5,1,if(tmp_slope_20m>=5&&tmp_slope_20m<10,2,if(tmp_slope_20m>=10&&tmp_slope_20m<15,3,if(tmp_slope_20m>=15&&tmp_slope_20m<20,4,if(tmp_slope_20m>=20&&tmp_slope_20m<25,5,if(tmp_slope_20m>=25&&tmp_slope_20m<30,6,if(tmp_slope_20m>=30&&tmp_slope_20m<35,7,if(tmp_slope_20m>=35&&tmp_slope_20m<40,8,if(tmp_slope_20m>=40,9))))))))))"

r.param.scale input=Imperia_20m output=morfologia_20m size=9 method=feature
r.reclass input=morfologia_20m output=morfologia_20m_reclass rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_morfologia.txt

g.region raster=$dem_iniziale

r.stats -c -n --overwrite input=Area_calibrazione,slope_classi_20m output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_slope_20m.txt separator=comma
r.stats -c -n --overwrite input=Area_calibrazione,morfologia_20m_reclass output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_morfologia_reclass_20m.txt separator=comma

######################################################################################

#g.region vector=$regione
#g.region res=90
#g.region -p
#r.mask vector=$regione
#r.mapcalc "dem90_90m = $dem90" --overwrite
#g.remove -f type=raster name=dem_90_senza_buchi
#r.mask -r
#g.region raster=dem90_90m
#r.slope.aspect elevation=dem90_90m slope=tmp_slope_aspect_90m --overwrite --quiet
#r.mapcalc "slope_aspect_90m_classi = if($dem_iniziale==0,null(),if(tmp_slope_aspect_90m>=0&&tmp_slope_aspect_90m<5,1,if(tmp_slope_aspect_90m>=5&&tmp_slope_aspect_90m<10,2,if(tmp_slope_aspect_90m>=10&&tmp_slope_aspect_90m<15,3,if(tmp_slope_aspect_90m>=15&&tmp_slope_aspect_90m<20,4,if(tmp_slope_aspect_90m>=20&&tmp_slope_aspect_90m<25,5,if(tmp_slope_aspect_90m>=25&&tmp_slope_aspect_90m<30,6,if(tmp_slope_aspect_90m>=30&&tmp_slope_aspect_90m<35,7,if(tmp_slope_aspect_90m>=35&&tmp_slope_aspect_90m<40,8,if(tmp_slope_aspect_90m>=40,9))))))))))" --overwrite

####sbagliato(?!)####
#g.region vector=$regione
#g.region res=90
#g.region -p
#r.mask vector=$regione
#r.mapcalc "dem90_90m = $dem90" --overwrite
#g.remove -f type=raster name=dem_90_senza_buchi
#r.mask -r
#g.region raster=dem90_90m
#r.slope.aspect elevation=dem90_90m slope=tmp_slope_aspect_90m --overwrite --quiet
#r.mapcalc "slope_aspect_90m_classi = if($dem_iniziale==0,null(),if(tmp_slope_aspect_90m>=0&&tmp_slope_aspect_90m<5,1,if(tmp_slope_aspect_90m>=5&&tmp_slope_aspect_90m<10,2,if(tmp_slope_aspect_90m>=10&&tmp_slope_aspect_90m<15,3,if(tmp_slope_aspect_90m>=15&&tmp_slope_aspect_90m<20,4,if(tmp_slope_aspect_90m>=20&&tmp_slope_aspect_90m<25,5,if(tmp_slope_aspect_90m>=25&&tmp_slope_aspect_90m<30,6,if(tmp_slope_aspect_90m>=30&&tmp_slope_aspect_90m<35,7,if(tmp_slope_aspect_90m>=35&&tmp_slope_aspect_90m<40,8,if(tmp_slope_aspect_90m>=40,9))))))))))" --overwrite



#################################
#creo le classi di quota
#################################

g.region raster=$dem_iniziale
g.region -p
r.mapcalc --overwrite expression="classi_quota_250=if($dem_iniziale==0,null(),int($dem_iniziale/250+1))"


#################################
#ACCUMULAZIONE - Dimensione minima bacini 1km2 = 1000000 m2 = 5x5x40000
################################
r.fill.dir --overwrite input=$dem_iniziale output=Imperia_depressionless direction=Imperia_flow_direction
r.watershed --overwrite elevation=Imperia_depressionless threshold=40000 accumulation=accumulazione
r.mapcalc --overwrite expression="log_accumulazione = log(abs( accumulazione) + 1)"
r.mapcalc --overwrite expression="log_accumulazione_interi = int( log_accumulazione )"
r.reclass --overwrite input=log_accumulazione_interi output=classi_accumulazione rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/reclass_accumulazione..txt
r.stats -c -n --overwrite input=Area_calibrazione,classi_accumulazione output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_accumulazione.txt separator=comma


#Per quel che riguarda Imperia qui importo i file di litologia, uso suolo e strade già fatti per la Liguria, l'aggressività climatica si usa quella interpolata sui txti Arpal. Per fare altre regioni bisogna implementare lo script con i txti delle stesse.


#################################
# geologia
################################

g.copy raster=litologia_reclass@liguria_frane_roberto,litologia_reclass
g.copy raster=classi_litologia@rovegno_frane_liguria,classi_litologia
g.copy raster=classi_uso_suolo@rovegno_frane_liguria,classi_uso_suolo
r.mask vector=$regione
r.mapcalc "classi_litologia = classi_litologia" --overwrite
r.mapcalc "classi_uso_suolo = classi_uso_suolo" --overwrite
r.mapcalc "litologia_reclass = litologia_reclass" --overwrite
r.mask -r
r.reclass input=classi_litologia output=classi_litologia_crescente rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_litologia.txt
r.reclass --overwrite input=classi_uso_suolo output=classi_uso_suolo_crescente rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_uso_suolo_crescente.txt

#################################
# strade
################################

g.copy raster=buf_strade_imperia_ok@Lorenzo_IMPERIA,buf_strade
r.reclass input=buf_strade output=buf_strade_crescente rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_distanza_strade.txt
r.stats --overwrite -c -n input=Area_calibrazione,buf_strade output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_strade.txt separator=comma
r.stats --overwrite -c -n input=Area_calibrazione,buf_strade_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_strade_crescente.txt separator=comma

#################################
# aggressivita' climatica
################################

g.copy raster=aggressivita_climatica@Lorenzo_IMPERIA,aggressivita_climatica
g.copy raster=AC_6classi_imperia@Lorenzo_IMPERIA,AC_2classi
g.copy raster=aggressivita_climatica@rovegno_frane_liguria,aggressivita_climatica
r.mask vector=$regione
r.mapcalc "aggressivita_climatica = aggressivita_climatica" --overwrite
r.mask -r
#r.reclass input=aggressivita_climatica output=AC_6classi rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_AC.txt
r.reclass input=aggressivita_climatica output=AC_4classi rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_AC.txt
r.reclass input=AC_6classi output=AC_6classi_crescente rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_AC_6classi_crescente.txt

g.region raster=$dem_iniziale
r.mask vector=$regione
r.mapcalc "AC_meteoswiss = AC_meteoswiss" --overwrite
r.mask -r
r.reclass input=AC_meteoswiss output=AC_meteoswiss_5classi rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_AC_meteoswiss.txt


r.stats -c -n input=Area_calibrazione,AC_meteoswiss_5classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_AC_meteoswiss_5classi.txt separator=comma
r.reclass input=AC_meteoswiss_5classi output=AC_meteoswiss_5classi_crescente rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/reclass_AC_meteoswiss_crescente.txt
r.stats -c -n input=Area_calibrazione,AC_meteoswiss_5classi_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_AC_meteoswiss_5classi_crescente.txt separator=comma

r.stats -c -n input=Area_calibrazione,AC_6classi_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_AC_6classi_crescente.txt separator=comma
r.stats -c -n input=Area_calibrazione,AC_6classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_AC_6classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,AC_4classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_AC_4classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,AC_2classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_AC_2classi.txt separator=comma


r.stats -c -n input=Area_calibrazione,aspect_classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_aspect_8classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_4classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_aspect_4classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_4classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_aspect_4classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_4classi_mapcalc output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_aspect_4classi_mapcalc.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_2classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_aspect_2classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_4classi_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_aspect_4classi_crescente.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_2classi_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_aspect_2classi_crescente.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_4classi_crescente_scaletta output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_aspect_4classi_crescente_scaletta.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_4classi_B output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_aspect_4classi_B.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_4classi_B_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_aspect_4classi_B_crescente.txt separator=comma
r.stats -c -n input=Area_calibrazione,aspect_4classi_C output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_aspect_4classi_C.txt separator=comma



r.stats -c -n input=Area_calibrazione,slope_classi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_slope_9classi.txt separator=comma
r.stats -c -n input=Area_calibrazione,slope_classi_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_slope_9classi_crescente.txt separator=comma


r.stats -c -n input=Area_calibrazione,classi_quota_250 output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_quota_250.txt separator=comma


r.stats -c -n input=Area_calibrazione,classi_litologia output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_litologia.txt separator=comma
r.stats -c -n input=Area_calibrazione,classi_litologia_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_classi_litologia_crescente.txt separator=comma


r.stats -c -n input=Area_calibrazione,litologia_reclass output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_litologia_reclass_28.txt separator=comma


r.stats -c -n input=Area_calibrazione,classi_uso_suolo output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_uso_suolo.txt separator=comma
r.stats -c -n input=Area_calibrazione,classi_uso_suolo_crescente output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Analisi_univariata/Imperia/stats_classi_uso_suolo_crescente.txt separator=comma


#####################################################################################################################################################################################################

#Usare divisione in classi crescente solo per variabili non categoriali (litologia ed uso del suolo) ed esposizione, per la pendenza e le quote non ha senso perchè hanno un loro ordine naturale.

#####################################################################################################################################################################################################

#################################
# Regressione - aspect_4classi - come 1°tentativo uso l'ordine di rovegno, sceglierò i parametri più influenti e ne varierò l'ordine per vedere come vaiano AIC ed Rq
################################

pendenza="slope_classi"
uso_suolo="classi_uso_suolo_crescente"
litologia="classi_litologia_crescente"
distanza_strade="buf_strade_crescente"
accumulazione="classi_accumulazione"
esposizione="aspect_4classi_crescente_scaletta"
esposizione_8="aspect_classi"
esposizione_2="aspect_2classi_crescente"
quota="classi_quota_250"
AC="AC_2classi"


r.mapcalc expression="logit_imperia=log(Area_calibrazione + 0.00000001) - log(1 - Area_calibrazione + 0.00000001)"

#2 variabili (accumulazione & esposizione)
r.regression.multi --overwrite mapx="$accumulazione,$esposizione" mapy="logit_imperia" residuals="res_2" estimates="est_2" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_4classi/Imperia_4_coeff_regressione_2var.txt"

#3 variabili (+AC)
r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC" mapy="logit_imperia" residuals="res_3" estimates="est_3" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_4classi/Imperia_4_coeff_regressione_3var.txt"

#4 variabili (+litologia)
r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC,$litologia" mapy="logit_imperia" residuals="res_4" estimates="est_4" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_4classi/Imperia_4_coeff_regressione_4var.txt"

#5 variabili (+pendenza)
r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC,$litologia,$pendenza" mapy="logit_imperia" residuals="res_5" estimates="est_5" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_4classi/Imperia_4_coeff_regressione_5var.txt"

#6 variabili (+quota)
r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC,$litologia,$pendenza,$quota" mapy="logit_imperia" residuals="res_6" estimates="est_6" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_4classi/Imperia_4_coeff_regressione_6var.txt"

#7 variabili (+distanza_strade)
r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC,$litologia,$pendenza,$quota,$distanza_strade" mapy="logit_imperia" residuals="res_7" estimates="est_7" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_4classi/Imperia_4_coeff_regressione_7var.txt"

#8 variabili (+uso_suolo)
r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC,$litologia,$pendenza,$quota,$distanza_strade,$uso_suolo" mapy="logit_imperia" residuals="res_8" estimates="est_8" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_4classi/Imperia_4_coeff_regressione_8var.txt"


#################################
# Regressione - aspect 8 classi
################################


# #2 variabili (slope & uso suolo)
# r.regression.multi --overwrite mapx="$pendenza,$uso_suolo" mapy="logit_imperia" residuals="res_2" estimates="est_2" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_8classi/imperia_8_coeff_regressione_2var.txt"

# #3 variabili (+litologia)
# r.regression.multi --overwrite mapx="$litologia,$pendenza,$uso_suolo" mapy="logit_imperia" residuals="res_3" estimates="est_3" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_8classi/imperia_8_coeff_regressione_3var.txt"

# #4 variabili (+accumulazione)
# r.regression.multi --overwrite mapx="$accumulazione,$litologia,$pendenza,$uso_suolo" mapy="logit_imperia" residuals="res_4" estimates="est_4" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_8classi/imperia_8_coeff_regressione_4var.txt"

# #5 variabili (+aspect)
# r.regression.multi --overwrite mapx="$esposizione_8,$accumulazione,$litologia,$pendenza,$uso_suolo" mapy="logit_imperia" residuals="res_5" estimates="est_5" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_8classi/imperia_8_coeff_regressione_5var.txt"

# #6 variabili (+AC)
# r.regression.multi --overwrite mapx="$AC,$esposizione_8,$accumulazione,$litologia,$pendenza,$uso_suolo" mapy="logit_imperia" residuals="res_6" estimates="est_6" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_8classi/imperia_8_coeff_regressione_6var.txt"

# #7 variabili (+classi_quota)
# r.regression.multi --overwrite mapx="$quota,$AC,$esposizione_8,$accumulazione,$litologia,$pendenza,$uso_suolo" mapy="logit_imperia" residuals="res_7" estimates="est_7" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_8classi/imperia_8_coeff_regressione_7var.txt"

# #8 variabili (+buf_strade_ok)
# r.regression.multi --overwrite mapx="$distanza_strade,$quota,$AC,$esposizione_8,$accumulazione,$litologia,$pendenza,$uso_suolo" mapy="logit_imperia" residuals="res_8" estimates="est_8" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_8classi/imperia_8_coeff_regressione_8var.txt"


# #################################
# # Regressione - aspect 2 classi
# ################################

#2 variabili (slope & uso suolo)
#r.regression.multi --overwrite mapx="$pendenza,$uso_suolo" mapy="logit_imperia" residuals="res_2" estimates="est_2" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_2classi/Imperia_2_coeff_regressione_2var.txt"

#3 variabili (+litologia)
#r.regression.multi --overwrite mapx="$pendenza,$uso_suolo,$litologia" mapy="logit_imperia" residuals="res_3" estimates="est_3" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_2classi/Imperia_2_coeff_regressione_3var.txt"

#4 variabili (+accumulazione)
#r.regression.multi --overwrite mapx="$pendenza,$uso_suolo,$litologia,$accumulazione" mapy="logit_imperia" residuals="res_4" estimates="est_4" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_2classi/Imperia_2_coeff_regressione_4var.txt"

#5 variabili (+aspect)
#r.regression.multi --overwrite mapx="$pendenza,$uso_suolo,$litologia,$accumulazione,$esposizione_2" mapy="logit_imperia" residuals="res_5" estimates="est_5" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_2classi/Imperia_2_coeff_regressione_5var.txt"

#6 variabili (+AC)
#r.regression.multi --overwrite mapx="$pendenza,$uso_suolo,$litologia,$accumulazione,$esposizione_2,$AC" mapy="logit_imperia" residuals="res_6" estimates="est_6" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_2classi/Imperia_2_coeff_regressione_6var.txt"

#7 variabili (+classi_quota)
#r.regression.multi --overwrite mapx="$pendenza,$uso_suolo,$litologia,$accumulazione,$esposizione_2,$AC,$quota" mapy="logit_imperia" residuals="res_7" estimates="est_7" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_2classi/Imperia_2_coeff_regressione_7var.txt"

#8 variabili (+buf_strade_ok)
#r.regression.multi --overwrite mapx="$pendenza,$uso_suolo,$litologia,$accumulazione,$esposizione_2,$AC,$quota,$distanza_strade" mapy="logit_imperia" residuals="res_8" estimates="est_8" output="/home/lorenzo/Scrivania/GRASS/Script_Lorenzo/Regressione/Imperia/Esposizione_2classi/Imperia_2_coeff_regressione_8var.txt"

#Z_Imperia
####Bisogna scriverla a mano mettendo i b0 che escono da regression.multi a moltiplicare le mappe.####
r.mapcalc --overwrite "Z_Imperia=-23.0546760 + 0.2763460 * $accumulazione + 0.2245310 * $esposizione + 0.1846840 * $AC + 0.6748610 * $litologia - 0.0679820 * $pendenza - 0.1087220 * $quota + 0.0917460 * $distanza_strade + 0.0782230 * $uso_suolo"

#Suscettibilità
#r.mapcalc "susc_8 = exp(est_8) / (1 + exp(est_8) )"

r.neighbors input=classi_susc_Imperia_morfologia_E@Script_Imperia_frane_Bovolenta output=classi_susc_Imperia_morfologia_E_pulito method=mode

exit 0
