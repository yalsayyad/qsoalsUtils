# Britt Lundgren
# August 19, 2014
#
# Script to make training samples for Mg II ML scoring from DR4 quasars

def popchoice(seq):
    # raises IndexError if seq is empty
    return seq.pop(random.randrange(len(seq)))

import sklearn
import numpy as np
from sklearn.ensemble import RandomForestClassifier
import pylab as pl
from sklearn.cross_validation import train_test_split
import random
import pyfits

'''
# make unique list of all Pitt quasars in DR7 (run once)
counter=0
uniqueqsos = []
fout = open('quider/unique_quider_qsos_inDR7.dat', 'w')
for line in open('quider/quider_qsos_inDR7.dat').readlines():
    cols = line.split()
    if cols[0] not in uniqueqsos:
        uniqueqsos.append(cols[0])
        print >> fout, line.strip()
        counter+=1
fout.close()
'''
# Read in list of DR4 quasars in DR7
pfm = []
for line in open('quider/unique_quider_qsos_inDR7.dat').readlines():
    cols = line.split()
    pfm.append(cols[0])
print "%i unique DR4 quasars in DR7" % (len(pfm))

'''
# fetch all DR7 Mg II detections in DR4 quasar sample (run once)
f = pyfits.open('DR7_QSOALS_catalog_071614.fits')
tbdata = f[1].data
fout = open('dr7_MgII_in_dr4.dat', 'w')
print >> fout, "# plate-fiber-mjd  zqso imag zabs grade type MgII_ew1 MgIIewer1 MgII_ew2 MgII_ewer2 beta BAL1 BAL2"
counter=0
for m in range(0,len(pfm)):
    pfmarr = pfm[m].split('-')
    plate = int(pfmarr[0])
    fiber = int(pfmarr[1])
    pfmstr = str(pfmarr[0]).zfill(4)+'-'+str(pfmarr[1]).zfill(3)+'-'+str(pfmarr[2])
    index=-1
    tb2 = np.where(tbdata.field('plate')==plate)
    for n in tb2[0]:
        MgII_ew1 = float(tbdata.field('EW_obs')[n][25])
        MgII_ew2 = float(tbdata.field('EW_obs')[n][26])
        MgII_ewer1 = float(tbdata.field('EW_err_obs')[n][25])
        MgII_ewer2 = float(tbdata.field('EW_err_obs')[n][26])
        if tbdata.field('plate')[n]!=plate:
            print "something wrong with the indexing!!"
        if tbdata.field('fiber')[n]==fiber and MgII_ew1>0. and MgII_ew2>0. and MgII_ewer1>0. and MgII_ewer2>0. and MgII_ew1/MgII_ewer1>4. and tbdata.field('type')[n]!='?':
            zabs = float(tbdata.field('z_abs')[n])
            zqso = float(tbdata.field('z_qso')[n])
            beta = float(tbdata.field('beta')[n])
            BAL1 = int(tbdata.field('BAL_flag')[n])
            BAL2 = int(tbdata.field('BAL_flag2')[n])
            imag = float(tbdata.field('imag')[n])
            grade = str(tbdata.field('grade')[n])
            dtype = str(tbdata.field('type')[n])
            print >> fout, "%s %6.5f %4.2f %6.5f %3s %4s %6.5f %6.5f %6.5f %6.5f %6.5f %3i %3i" % (pfmstr, zqso, imag, zabs, grade, dtype, MgII_ew1, MgII_ewer1, MgII_ew2, MgII_ewer2, beta, BAL1, BAL2)
            counter+=1
fout.close()
print "%i Mg II detections in DR4 quasars" % (counter)


## read in all DR7 Mg II detections in DR4 quasars
#counter=0
#index_list = []
#lines = []
#for line in open('quider/dr7_absorbers_in_dr4.dat').readlines():
#    # plate-fiber-mjd dr7zabs dr7zMgIIew dr7MgIIewer dr7grade dr7zqso dr7type dr7zMgII2ew dr7MgII2ewer
#    if line.startswith('#')==0:
#        cols = line.split()
#        if ('M' in str(cols[6]) or 'F' in str(cols[6])) and float(cols[2])>0.:
#            lines.append(line.strip())
#            counter+=1
#            index_list.append(counter)
'''
counter=0
index_list = []
lines = []
for line in open('dr7_MgII_in_dr4.dat').readlines():
    # plate-fiber-mjd  zqso imag zabs grade type MgII_ew1 MgIIewer1 MgII_ew2 MgII_ewer2 beta BAL1 BAL2
    if line.startswith('#')==0:
        cols = line.split()
        lines.append(line.strip())
        counter+=1
        index_list.append(counter)

print "Total number of 4-sigma Mg II detections in the DR4: %i" % (counter)
print " "

# randomly draw from the list to make subset
indices=[]
for m in range(0,100):
    indices.append(popchoice(index_list))

# write out to new catalog for visual inspection
fout = open('randsubset_dr7_absorbers_in_dr4.dat', 'w')
print >> fout, "# plate-fiber-mjd  zqso imag zabs grade type MgII_ew1 MgIIewer1 MgII_ew2 MgII_ewer2 beta BAL1 BAL2"
lines_short = []
for index in indices:
    print >> fout, lines[index]
    lines_short.append(lines[index])
fout.close()


# determine the fraction of overlapping detections with Pitt
pfm_pitt = []
zabs_pitt = []
overlap=0.
fout = open('randsubset_dr7_absorbers_in_dr4_notes.dat', 'w')
for line in open('quider/MgII_absorber_catalog').readlines():
    cols = line.split()
    plate = int(cols[2])
    fiber = int(cols[3])
    mjd = int(cols[1])
    pfm_pitt.append(str(plate).zfill(4)+'-'+str(fiber).zfill(3)+'-'+str(mjd))
    zabs_pitt.append(float(cols[4]))
'''
for line in open('quider/absorbers_recovered_by_Pitt.dat'):
    if line.startswith('#')==0:
        cols = line.split()
        pfm.append(str(cols[0]))
        zabs.append(float(cols[4]))
'''

overlapping=[]
for line in lines_short:
    cols = line.split()
    found=0
    for m in range(0,len(pfm_pitt)):
        if str(cols[0])==pfm_pitt[m]:
            if abs(zabs_pitt[m]-float(cols[3]))<0.003:
                overlap+=1.
                found=1
    if found==0:
        overlapping.append(0)
    else:
        overlapping.append(1)
        
# print out overlapping and non-overlapping systems to notes file for input to VI tool
print >> fout, "# plate-fiber-mjd  zqso imag zabs grade type MgII_ew1 MgIIewer1 MgII_ew2 MgII_ewer2 beta BAL1 BAL2 VI notes"
for m in range(0,len(overlapping)):
    if overlapping[m]==1:
        cols = lines_short[m].split()
        print >> fout, "%s good" % lines_short[m].strip()

for m in range(0,len(overlapping)):
    if overlapping[m]==0:
        cols = lines_short[m].split()
        print >> fout, "%s" % lines_short[m].strip()
        #print >> fout, "%20s %6.5f %6.5f %6.5f %6.5f %6.2f %2s %3s" % (str(cols[0]), float(cols[5]), float(cols[1]), float(cols[2]), float(cols[3]), 2796.4*(1.+float(cols[1])), str(cols[4]), str(cols[6]))

print "Fraction of random sample with detections in Pitt: %f" % (overlap/len(indices))
        

    

alldr7grades = []
grades_recovered = []
grades_notrecovered = []
matchedfrac = []
unmatchedfrac = []
for line in open('quider/absorbers_recovered_by_Pitt.dat').readlines():
    cols = line.split()
    if str(cols[0])!='#':
        alldr7grades.append(str(cols[7]))
        grades_recovered.append(str(cols[7]))
for line in open('quider/absorbers_not_recovered_by_Pitt.dat').readlines():
    cols = line.split()
    if str(cols[0])!='#':
        alldr7grades.append(str(cols[6]))
        grades_notrecovered.append(str(cols[6]))

# find grade breakdown of entire DR7 catalog
grades = ['A','B', 'C', 'C*', 'D', 'D*', 'E', 'E*']
for grade in grades:
    countgrade=0.
    for m in alldr7grades:
        if m==grade:
            countgrade+=1.
    #print "Fraction of all DR7 absorbers grade %2s: %5.2f" % (grade, countgrade/len(alldr7grades))
print " "

# find grade breakdown of matches to Q11
for grade in grades:
    countgrade=0.
    for m in grades_recovered:
        if m==grade:
            countgrade+=1.
    #print "Fraction of all Q11 matched absorbers grade %2s: %5.2f" % (grade, countgrade/len(grades_recovered))
    matchedfrac.append(countgrade/len(grades_recovered))
print " "

# find grade breakdown of discrepant systems
for grade in grades:
    countgrade=0.
    for m in grades_notrecovered:
        if m==grade:
            countgrade+=1.
    #print "Fraction of all discrepant absorbers grade %2s: %5.2f" % (grade, countgrade/len(grades_notrecovered))
    unmatchedfrac.append(countgrade/len(grades_notrecovered))


