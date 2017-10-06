#!/bin/sh


mappa_susc=suscettibilita_torino


#Suscettibilità
# r.mapcalc --overwrite "suscettibilita_torino = exp(est_8_finale) / (1 + exp(est_8_finale) )"

# r.mask raster=Area_calibrazione maskcats=1

# r.univar map=suscettibilita_torino output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Suscettibilita/Torino/susc_torino_finale_IFFI.txt separator=comma

# r.mask -r

# r.univar map=suscettibilita_torino output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Suscettibilita/Torino/susc_torino_finale.txt separator=comma

limite1=1.56e-08
limite2=2.79e-08

r.mapcalc --overwrite "classi_susc_torino_E = if($mappa_susc<$limite1,1, if($mappa_susc<$limite2,2,3))"
r.colors map=classi_susc_torino_E rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/colori_suscettibilita.txt
exit 0
