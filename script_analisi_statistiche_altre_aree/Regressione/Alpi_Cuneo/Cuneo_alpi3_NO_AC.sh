#!/bin/sh
# script per analisi univariata generale, servono dem_iniziale, frane considerate, litologia, tratte stradali ecc. Li importo e posso usare lo script.


#################################
# Regressione - aspect_8classi 
################################

litologia="classi_litologia_crescente"
quota="classi_quota_250"
esposizione="aspect_classi"
accumulazione="classi_accumulazione"
distanza_strade="buf_strade"
pendenza="classi_morfologia_crescente"
uso_suolo="classi_uso_suolo_crescente"






#r.mapcalc expression="logit_cuneo=log(Area_calibrazione + 0.00000001) - log(1 - Area_calibrazione + 0.00000001)"

# #2 variabili 
# r.regression.multi --overwrite mapx="$litologia,$quota" mapy="logit_cuneo" residuals="res_2" estimates="est_2" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/Cuneo_alpi/cuneo_8_coeff_regressione_2var.txt"

# #3 variabili 
# r.regression.multi --overwrite mapx="$litologia,$quota,$esposizione" mapy="logit_cuneo" residuals="res_3" estimates="est_3" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/Cuneo_alpi/cuneo_8_coeff_regressione_3var.txt"

# #4 variabili 
# r.regression.multi --overwrite mapx="$litologia,$quota,$accumulazione,$esposizione" mapy="logit_cuneo" residuals="res_4" estimates="est_4" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/Cuneo_alpi/cuneo_8_coeff_regressione_4var.txt"

# #5 variabili 
# r.regression.multi --overwrite mapx="$litologia,$quota,$accumulazione,$esposizione,$accumulazione" mapy="logit_cuneo" residuals="res_5" estimates="est_5" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/Cuneo_alpi/cuneo_8_coeff_regressione_5var.txt"

# #6 variabili 
# r.regression.multi --overwrite mapx="$litologia,$quota,$accumulazione,$esposizione,$accumulazione,$distanza_strade" mapy="logit_cuneo" residuals="res_6" estimates="est_6" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/Cuneo_alpi/cuneo_8_coeff_regressione_6var.txt"

# #7 variabili
# r.regression.multi --overwrite mapx="$litologia,$quota,$accumulazione,$esposizione,$accumulazione,$distanza_strade,$pendenza" mapy="logit_cuneo" residuals="res_7" estimates="est_7" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/Cuneo_alpi/cuneo_8_coeff_regressione_7var.txt"

#8 variabili 
r.regression.multi --overwrite mapx="$litologia,$quota,$esposizione,$accumulazione,$distanza_strade,$pendenza,$uso_suolo" mapy="logit_cuneo" residuals="res_8_finale" estimates="est_8_finale" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/Cuneo_alpi/cuneo_8_coeff_regressione_8var.txt"
exit 0