#!/bin/sh
# UNIGE copyleft
# Author: Roberto Marzocchi

#out
#r.mapcalc expression="logit_frana=if(tmp_frane_regressione==1,5,-5)" --o

#Out
r.mapcalc expression="logit_frana=log(tmp_frane_regressione+0.00000001)-log(1-tmp_frane_regressione+0.00000001)" --o
#r.mapcalc expression="logit_frana=if(tmp_frane_regressione==1,999,-999)" --o

#out
#r.mapcalc expression="logit_frana=log(tmp_frane_regressione+0.000001)-log(1-tmp_frane_regressione+0.000001)" --o



#2 variabili (slope & uso suolo)
r.regression.multi mapx=slope_classi,uso_suolo_6classi mapy=logit_frana output=Out_2 residuals=res_2 estimates=est_2 --o

#3 variabili (+litologia)
r.regression.multi mapx=litologia_ok,slope_classi,uso_suolo_6classi mapy=logit_frana output=Out_3 residuals=res_3 estimates=est_3 --o

#4 variabili (+accumulazione)
r.regression.multi mapx=accumulazione_classi,slope_classi,uso_suolo_6classi,litologia_ok mapy=logit_frana output=Out_4 residuals=res_4 estimates=est_4 --o

#5 variabili (+aspect)
r.regression.multi mapx=accumulazione_classi,slope_classi,aspect_classi,uso_suolo_6classi,litologia_ok mapy=logit_frana output=Out_5 residuals=res_5 estimates=est_5 --o

#6 variabili (+AC)
r.regression.multi mapx=accumulazione_classi,slope_classi,AC_classi,aspect_classi,uso_suolo_6classi,litologia_ok mapy=logit_frana output=Out_6 residuals=res_6 estimates=est_6 --o


#7 variabili (+classi_quota)
r.regression.multi mapx=accumulazione_classi,slope_classi,AC_classi,aspect_classi,classi_quota_100,uso_suolo_6classi,litologia_ok mapy=logit_frana output=Out7 residuals=res_7 estimates=est_7 --o


#8 variabili (+buf_strade_ok)
r.regression.multi mapx=accumulazione_classi,slope_classi,AC_classi,aspect_classi,classi_quota_100,buf_strade_ok,uso_suolo_6classi,litologia_ok mapy=logit_frana output=Out_8 residuals=res_8 estimates=est_8 --o



#r.mapcalc expression="Z_8=-14.000289+accumulazione_classi*0.013354+slope_classi*0.003206+AC_classi*0.00847+aspect_classi*0.002778+classi_quota_100*(-0.001091)+buf_strade_ok*(-0.023476)+uso_suolo_6classi*0.042243+0.045571*litologia_ok"



#	accumulazione_classi	slope_classi	AC_classi	aspect_classi	classi_quota_100	buf_strade_ok	uso_suolo_6classi	litologia_ok
#-14.000289	0.013354	0.003206	0.00847	0.002778	-0.001091	-0.023476	0.042243	0.045571



r.mapcalc expression="susc_8=exp(est_8)/(1+exp(est_8))" --o


#R

#library("spgrass6")
#mapx=accumulazione_classi,slope_classi,AC_classi,aspect_classi,classi_quota_100,buf_strade_ok,uso_suolo_6classi,litologia_ok 
#mapy=tmp_frane_regressione

#slope_classi <- readRAST6("slope_classi")



