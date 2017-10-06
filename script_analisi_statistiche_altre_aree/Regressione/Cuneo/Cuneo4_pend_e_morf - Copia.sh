#!/bin/sh
# script per analisi univariata generale, servono dem_iniziale, frane considerate, litologia, tratte stradali ecc. Li importo e posso usare lo script.


#################################
# Regressione - aspect_8classi 
################################

litologia="classi_litologia_crescente"
quota="classi_quota_250"
esposizione="aspect_4classi_crescente"
accumulazione="classi_accumulazione"
pendenza="slope_3classi"
morfologia="classi_morfologia_crescente"
uso_suolo="classi_uso_suolo_crescente"
AC="AC_4classi_come_imperia"
distanza_strade="buf_strade"






r.mapcalc expression="logit_cuneo=log(Area_calibrazione + 0.00000001) - log(1 - Area_calibrazione + 0.00000001)"

# #2 variabili (litologia & quota)
# r.regression.multi --overwrite mapx="$litologia,$quota" mapy="logit_cuneo" residuals="res_2" estimates="est_2" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_2var.txt"

# #3 variabili (+esposizione)
# r.regression.multi --overwrite mapx="$litologia,$quota,$esposizione" mapy="logit_cuneo" residuals="res_3" estimates="est_3" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_3var.txt"

# #4 variabili (+accumulazione)
# r.regression.multi --overwrite mapx="$litologia,$quota,$esposizione,$accumulazione" mapy="logit_cuneo" residuals="res_4" estimates="est_4" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_4var.txt"

# #5 variabili (+pendenza)
# r.regression.multi --overwrite mapx="$litologia,$quota,$esposizione,$accumulazione,$pendenza" mapy="logit_cuneo" residuals="res_5" estimates="est_5" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_5var.txt"

# #6 variabili (+morfologia)
# r.regression.multi --overwrite mapx="$litologia,$quota,$esposizione,$accumulazione,$pendenza,$morfologia" mapy="logit_cuneo" residuals="res_6" estimates="est_6" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_6var.txt"

# #7 variabili (+uso suolo)
# r.regression.multi --overwrite mapx="$litologia,$quota,$esposizione,$accumulazione,$pendenza,$morfologia,$uso_suolo" mapy="logit_cuneo" residuals="res_7" estimates="est_7" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_7var.txt"

# #8 variabili (+AC)
# r.regression.multi --overwrite mapx="$litologia,$quota,$esposizione,$accumulazione,$pendenza,$morfologia,$uso_suolo,$AC" mapy="logit_cuneo" residuals="res_8" estimates="est_8" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_8var.txt"

#9 variabili (+distanza strade)
r.regression.multi --overwrite mapx="$litologia,$quota,$esposizione,$accumulazione,$pendenza,$morfologia,$uso_suolo,$AC,$distanza_strade" mapy="logit_cuneo" residuals="res_9_AC_7classi" estimates="est_9_AC_7classi" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_9var.txt"
exit 0