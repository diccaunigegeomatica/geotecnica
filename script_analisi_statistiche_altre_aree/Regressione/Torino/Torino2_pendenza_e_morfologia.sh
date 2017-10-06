#!/bin/sh
# script per analisi univariata generale, servono dem_iniziale, frane considerate, litologia, tratte stradali ecc. Li importo e posso usare lo script.


#################################
# Regressione - aspect_8classi 
################################

morfologia="classi_morfologia_crescente"
pendenza="slope_classi"
uso_suolo="classi_uso_suolo_crescente"
litologia="classi_litologia_crescente"
distanza_strade="buf_strade"
accumulazione="classi_accumulazione"
esposizione="aspect_4classi_crescente"
quota="classi_quota_250"
AC="AC_17km_reclass"


r.mapcalc expression="logit_torino=log(Area_calibrazione + 0.00000001) - log(1 - Area_calibrazione + 0.00000001)"

# #2 variabili (accumulazione & esposizione)
# r.regression.multi --overwrite mapx="$accumulazione,$esposizione" mapy="logit_torino" residuals="res_2" estimates="est_2" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_2var.txt"

# #3 variabili (+AC)
# r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC" mapy="logit_torino" residuals="res_3" estimates="est_3" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_3var.txt"

# #4 variabili (+litologia)
# r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC,$litologia" mapy="logit_torino" residuals="res_4" estimates="est_4" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_4var.txt"

# #5 variabili (+morfologia)
# r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC,$litologia,$morfologia" mapy="logit_torino" residuals="res_5" estimates="est_5" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_5var.txt"

# #6 variabili (+quota)
# r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC,$litologia,$morfologia,$quota" mapy="logit_torino" residuals="res_6" estimates="est_6" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_6var.txt"

# #7 variabili (+distanza_strade)
# r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC,$litologia,$morfologia,$quota,$distanza_strade" mapy="logit_torino" residuals="res_7" estimates="est_7" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_7var.txt"

#8 variabili (+uso_suolo)
#r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC,$litologia,$morfologia,$quota,$distanza_strade,$uso_suolo" mapy="logit_torino" residuals="res_8" estimates="est_8" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_8var.txt"

#9 variabili (+pendenza)
r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$AC,$litologia,$morfologia,$quota,$distanza_strade,$uso_suolo,$pendenza" mapy="logit_torino" residuals="res_9_AC_17km" estimates="est_AC_17km" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_9_coeff_regressione_9var_AC_17km.txt"
exit 0