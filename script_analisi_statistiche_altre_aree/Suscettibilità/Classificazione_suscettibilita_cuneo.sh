#!/bin/sh


mappa_susc=suscettibilita_cuneo_AC_4classi_come_imperia


#Suscettibilità
r.mapcalc --overwrite "suscettibilita_cuneo_AC_4classi_come_imperia = exp(est_9_AC_4classi_come_imperia) / (1 + exp(est_9_AC_4classi_come_imperia) )"

r.mask raster=Area_calibrazione maskcats=1

r.univar map=suscettibilita_cuneo_AC_4classi_come_imperia output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Suscettibilita/Cuneo/susc_cuneo_finale_IFFI.txt separator=comma

r.mask -r

r.univar map=suscettibilita_cuneo_AC_4classi_come_imperia output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Suscettibilita/Cuneo/susc_cuneo_finale.txt separator=comma

# limite1=2.12e-08
# limite2=2.11e-07

# r.mapcalc --overwrite "classi_susc_cuneo_AC_4classi_come_imperia_F = if($mappa_susc<$limite1,1, if($mappa_susc<$limite2,2,3))"
# r.colors map=classi_susc_cuneo_F rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/colori_suscettibilita.txt
exit 0
