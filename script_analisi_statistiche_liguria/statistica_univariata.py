#!/usr/bin/env python
#Gter copyleft 
#Roberto Marzocchi

import sys
import os
import math
import time
import atexit
import shutil,re,glob
from decimal import Decimal
import ast

from math import sqrt
from numpy import *



import getopt



def main(argv):
	mappa = ''
   	try:
      		opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
   	except getopt.GetoptError:
      		print 'grass_pulizia.py -i <inputfile>'
      		sys.exit(2)
   	for opt, arg in opts:
      		if opt == '-h':
	 		print 'grass_pulizia.py -i <mappa>'
	 		sys.exit()
      		elif opt in ("-i", "--ifile"):
			mappa = arg
   		print 'Input file is ', mappa


	space = re.compile(r'\s+')
	multiSpace = re.compile(r"\s\s+") 

	nomefile1 = "%s.dat" % mappa
	#nomefile1='st_aspect.dat'	
	ncell=[]
	check=[]
	classi=[]

	print "ok\n"
	print nomefile1
	#leggo le tre colonne dove nella prima c'e' il 2
	i=0
	n=0
	riga_prima=" "
	line= " "
	for riga in file(nomefile1): 
		#print riga
		riga_prima = line
		line = riga
		a = line.split(",")
		i+=1
		check.append((a[0]))
		#if (check[i-1]=='*'):
		classi.append(float(a[1]))
		ncell.append(float(a[2]))
		#print float(a[2])

	print ncell
	
	 

	frane=[]
	no_frane=[]
	
	i=0
	while i<len(classi):
		j=0
		ctrl_no=0
		ctrl_fr=0		
		while j<len(classi):
			if (check[j]=='*' and classi[j]==(i+1)):
				no_frane.append(ncell[j])
				ctrl_no=1				
			if (check[j]=='1' and classi[j]==(i+1)):
				frane.append(ncell[j])
				ctrl_fr=1	
			j+=1
			print j		
		if(ctrl_fr==0 and ctrl_no==1):
			frane.append(0)		
		if(ctrl_no==0 and ctrl_fr==1):		
			no_frane.append(0)		
		i+=1
		print i
	
	
	#nclassi=(len(ncell)-1)/2
	#print nclassi


	#frane = ncell[:nclassi]
	#no_frane = ncell[nclassi:(len(ncell)-1)]

	print "\n"
	print frane
	print "\n"
	print no_frane
	
	#quit()

	totale=sum(frane)+sum(no_frane)
	print "totale %.0f\n"%totale

	x=[]
	x=polyadd(frane,no_frane)
	print x

	p_x=x/totale
	print p_x
	p_evento_e_x=frane/totale
	print p_evento_e_x
	#controllare che non ci siano 0
	p_cond_x=[]	
	i=0	
	while i<len(p_x):
		if (p_x[i]>0):	
			p_cond_x.append(p_evento_e_x[i]/p_x[i])
		else:
			p_con_x.append(1)
		i+=1
	print p_cond_x





	#######################################################################################
	# stampa
	#######################################################################################

	nomefile_o = "%s_out.dat" % mappa
	#nomefile1.close
	#nomefile_o="geo_%s" % nomefile1
	#nomefile_o="tmp_output.txt"
	miofile = open(nomefile_o,'w')
	miofile.write("#classe p_x p_evento_e_x p_cond_x\n")
	j=0
	while j<len(p_cond_x):
		miofile.write("%.0f %.2f %.2f %.2f\n"%((j+1),p_x[j]*100,p_evento_e_x[j]*100,p_cond_x[j]*100))
		j+=1

	print "\n\nThe output file %s has been created" %nomefile_o

	import Gnuplot

	gp = Gnuplot.Gnuplot()

	if (len(p_cond_x)<=5):
		largh=10
	elif (len(p_cond_x)<=20):
		largh=15
	elif (len(p_cond_x)<=40):
		largh=20
	else :
		largh=25


	#gp('set term png')
	gp("set terminal postscript enhanced color size %.0f,4"%(largh))
	#gp('set out "output.png"')
	gp_out = 'set out "%s_out.ps"'%(mappa) 
	print gp_out	
	gp(gp_out)


	#gp.title('Titolo')
	xlab='Classi %s'%(mappa[3:])
	gp.xlabel(xlab)
	gp.ylabel('Probabilita condizionata')
	#gp('set auto x')
	xxrange='set xrange [1:%.0f]'%(len(p_cond_x))
	gp(xxrange)
	

	#set terminal gif notransparent size 1500,300)
	gp("unset key") 
	

	gp('set xtic 1')
	#gp('set key noenhanced')
	gp('set grid')

	#gp('set style data histograms')
	#gp('set style fill solid 1.0 border -1')

	databuff = Gnuplot.File(nomefile_o, using='1:4', title="test", with_="impulses lt 1 lc 3 lw 20")
	gp.plot(databuff)




if __name__ == "__main__":
	main(sys.argv[1:])

