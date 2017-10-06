#!/bin/sh
# script per analisi univariata generale, servono dem_iniziale, frane considerate, litologia, tratte stradali ecc. Li importo e posso usare lo script.


#################################
# Regressione - aspect_8classi 
################################

pendenza="classi_morfologia_crescente"
uso_suolo="classi_uso_suolo_crescente"
litologia="classi_litologia_crescente"
distanza_strade="buf_strade"
accumulazione="classi_accumulazione"
esposizione="aspect_2classi_crescente"
quota="classi_quota_250"
#AC="AC_2classi"


r.mapcalc expression="logit_torino=log(Area_calibrazione + 0.00000001) - log(1 - Area_calibrazione + 0.00000001)"

# #2 variabili (accumulazione & esposizione)
# r.regression.multi --overwrite mapx="$accumulazione,$esposizione" mapy="logit_torino" residuals="res_2" estimates="est_2" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_2var.txt"

# #3 variabili (+litologia)
# r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$litologia" mapy="logit_torino" residuals="res_4" estimates="est_4" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_4var.txt"

# #4 variabili (+pendenza)
# r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$litologia,$pendenza" mapy="logit_torino" residuals="res_5" estimates="est_5" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_5var.txt"

# #5 variabili (+quota)
# r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$litologia,$pendenza,$quota" mapy="logit_torino" residuals="res_6" estimates="est_6" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_6var.txt"

# #6 variabili (+distanza_strade)
# r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$litologia,$pendenza,$quota,$distanza_strade" mapy="logit_torino" residuals="res_7" estimates="est_7" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_8_coeff_regressione_7var.txt"

#7 variabili (+uso_suolo)
r.regression.multi --overwrite mapx="$accumulazione,$esposizione,$litologia,$pendenza,$quota,$distanza_strade,$uso_suolo" mapy="logit_torino" residuals="res_8_no_AC" estimates="est_8_no_AC" output="/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Regressione/torino_no_AC_coeff_regressione_8var.txt"
exit 0