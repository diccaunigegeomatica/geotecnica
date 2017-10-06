#!/bin/sh
# script per analisi univariata generale, servono dem_iniziale, frane considerate, litologia, tratte stradali ecc. Li importo e posso usare lo script.


#################################
# Regressione - aspect_8classi 
################################

pendenza="slope_param_scale_4classi"
quota="classi_quota_250"
litologia="classi_litologia_crescente"
esposizione="aspect_2classi"
AC="AC_3classi"
uso_suolo="classi_uso_suolo_crescente"
accumulazione="classi_accumulazione"
distanza_strade="buf_strade"






r.mapcalc expression="logit_cuneo=log(Area_calibrazione + 0.00000001) - log(1 - Area_calibrazione + 0.00000001)"

# #2 variabili (pendenza & quota)
# r.regression.multi --overwrite mapx="$pendenza,$quota" mapy="logit_cuneo" residuals="res_2" estimates="est_2" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_2var.txt"

# #3 variabili (+litologia)
# r.regression.multi --overwrite mapx="$pendenza,$quota,$litologia" mapy="logit_cuneo" residuals="res_3" estimates="est_3" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_3var.txt"

# #4 variabili (+esposizione)
# r.regression.multi --overwrite mapx="$pendenza,$quota,$litologia,$esposizione" mapy="logit_cuneo" residuals="res_4" estimates="est_4" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_4var.txt"

# #5 variabili (+AC)
# r.regression.multi --overwrite mapx="$pendenza,$quota,$litologia,$esposizione,$AC" mapy="logit_cuneo" residuals="res_5" estimates="est_5" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_5var.txt"

# #6 variabili (+uso suolo)
# r.regression.multi --overwrite mapx="$pendenza,$quota,$litologia,$esposizione,$AC,$uso_suolo" mapy="logit_cuneo" residuals="res_6" estimates="est_6" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_6var.txt"

# #7 variabili (+accumulazione)
# r.regression.multi --overwrite mapx="$pendenza,$quota,$litologia,$esposizione,$AC,$uso_suolo,$accumulazione" mapy="logit_cuneo" residuals="res_7" estimates="est_7" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_7var.txt"

#8 variabili (+distanza strade)
r.regression.multi --overwrite mapx="$pendenza,$quota,$litologia,$esposizione,$AC,$uso_suolo,$accumulazione,$distanza_strade" mapy="logit_cuneo" residuals="res_8_finale" estimates="est_8_finale" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/cuneo_8_coeff_regressione_8var.txt"
exit 0