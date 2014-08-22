# Britt Lundgren
# August 20, 2014
#
# Script to use good detections, as verified by the Quider+ catalog and visual inspections,
# to estimate the likelihood of truth for each of the Chicago DR7 detections, using machine learning.
#
# This script reads in the VI output files renamed according to the naming convention:
# vi_files/randsubset_dr7_absorbers_in_dr4_notes_MgII_BL_##.dat
#
# To generate these files, make a random subset of Mg II absorbers, with a length of 100 at a time:
# >> python make_VIsamp_ML_MgII.py
#
# Then visually inspect the new random set with:
# >> python vi_inspect_MgII.py
#
# When finished, manually change the output file name to the convention referenced above.
#
# Then run this script:
# >> python gen_scores_MgII.py

def lettonum_grade(grade_str):
    if grade_str=='A':
        grade=1
    elif grade_str=='B':
        grade=2
    elif grade_str=='C':
        grade=3
    elif grade_str=='C*':
        grade=4
    elif grade_str=='C**':
        grade=5
    elif grade_str=='D':
        grade=6
    elif grade_str=='D*':
        grade = 7
    elif grade_str=='E':
        grade=8
    elif grade_str=='E*':
        grade=9
    return(grade)

def numtolet_grade(grade_num):
    if grade_num==1:
        grade='A'
    elif grade_num==2:
        grade='B'
    elif grade_num==3:
        grade='C'
    elif grade_num==4:
        grade='C*'
    elif grade_num==5:
        grade='C**'
    elif grade_num==6:
        grade='D'
    elif grade_num==7:
        grade='D*'
    elif grade_num==8:
        grade='E'
    elif grade_num==9:
        grade='E*'
    return(grade)

def lettonum_type(type_str):
    if type_str=='MCF':
        dtype=1
    elif type_str=='MF':
        dtype=2
    elif type_str=='MC':
        dtype=3
    elif type_str=='M':
        dtype=4
    elif type_str=='CF':
        dtype=5
    elif type_str=='F':
        dtype=6
    elif type_str=='C':
        dtype=7
    else:
        print type_str
    return(dtype)


def plotPairwiseClass(X, Y, labels=None, **kwargs):
    X = np.array(X)
    Y = np.array(Y)
    nVariables = X.shape[1]
    fig = pl.figure(1, (11, 8.5))
    grid = Grid(fig, 111, # similar to subplot(132)
            nrows_ncols = (nVariables, nVariables),
            axes_pad = 0.0,
            share_all=False,
            label_mode = "L",
            direction="column",
            )
    if labels is None:
        labels = ['var%d'%i for i in range(nVariables)]
    for i in range(nVariables):
        for j in range(nVariables):
            nSub = i * (nVariables) + j
            print nSub
            if i == j:
                n1, bins1 = np.histogram(X[:,i][np.where(np.array(Y)==1)], bins = 20)
                n0, bins1 = np.histogram(X[:,i][np.where(np.array(Y)==0)], bins=bins1)
                scaledata= np.max(X[:,i])/np.max((n0,n1))
                grid[nSub].plot(.5*(bins1[0:-1]+bins1[1:]), scaledata* n1, 'b-')
                grid[nSub].plot(.5*(bins1[0:-1]+bins1[1:]), scaledata* n0, 'r-')
                grid[nSub].text(.5, .8, labels[i])
            else:
                grid[nSub].scatter(X[:,i], X[:,j], c=Y, alpha=0.2, linewidth=0, cmap='seismic',**kwargs)
    return fig

import sklearn
import numpy as np
from sklearn.ensemble import RandomForestClassifier
import pylab as pl
from sklearn.cross_validation import train_test_split
import glob
import pyfits
from sklearn.metrics import mean_squared_error
from numpy import mean
from mpl_toolkits.axes_grid1 import Grid


## set rest-frame W (2796A) lower limit
wlim = 0.0

## Make test set
tt_fiber = []
tt_zabs = []
tt_W = []
tt_Werr = []
tt_DR = []
tt_SNR = []
tt_grade = []
tt_type = []
tt_zqso = []
tt_beta = []
tt_pfm = []
tt_imag = []
tt_BAL = []
counter=0

# fetch all DR7 Mg II detections in DR4 quasar sample (run once)
counter=0
for line in open('dr7_MgII_in_dr4.dat').readlines():
    if line.startswith('#')==0:
        cols = line.split()
        plate = int(str(cols[0]).split('-')[0])
        fiber = int(str(cols[0]).split('-')[1])
        mjd = int(str(cols[0]).split('-')[2])
        MgII_ew1 = float(cols[6])
        MgII_ew2 = float(cols[8])
        MgII_ewer1 = float(cols[7])
        MgII_ewer2 = float(cols[9])
        zabs = float(cols[3])
        zqso = float(cols[1])
        beta = float(cols[10])
        BAL1 = int(cols[11])
        BAL2 = int(cols[12])
        imag = float(cols[2])
        grade = str(cols[4])
        dtype = str(cols[5])
        counter+=1
        #if MgII_ew1/(1.+zabs)>wlim and ('M' in dtype or 'F' in dtype):
        if MgII_ew1/(1.+zabs)>wlim:

            tt_fiber.append(fiber)
            tt_zabs.append(zabs)
            tt_W.append(MgII_ew1/(1.+zabs))
            tt_Werr.append(MgII_ewer1/(1.+zabs))
            tt_SNR.append(MgII_ew1/MgII_ewer1)
            tt_DR.append(MgII_ew1/MgII_ew2)
            tt_grade.append(lettonum_grade(grade))
            tt_type.append(lettonum_type(dtype))
            tt_zqso.append(zqso)
            tt_beta.append(beta)
            tt_imag.append(imag)
            tt_BAL.append(BAL1)
            tt_pfm.append(str(plate).zfill(4)+'-'+str(fiber).zfill(3)+'-'+str(mjd))
X_test = []
print "%i Mg II detections in DR7 quasars" % (counter)

X_test = []
for m in range(0,len(tt_beta)):
    newarr = []
    newarr.append(tt_fiber[m])
    newarr.append(tt_zabs[m])
    newarr.append(tt_W[m])
    newarr.append(tt_SNR[m])
    newarr.append(tt_DR[m])
    newarr.append(tt_grade[m])
    newarr.append(tt_imag[m])
    newarr.append(tt_type[m])
    newarr.append(tt_zqso[m])
    newarr.append(tt_beta[m])
    newarr.append(tt_BAL[m])
    X_test.append(newarr)
feature_names = ['fiber', 'z_abs', 'MgII_W', 'MgII_SNR', 'DR', 'grade', 'imag', 'type', 'z_qso', 'beta', 'BAL']


# Make training set from VI output files
t_fiber = []
t_zabs = []
t_W = []
t_Werr = []
t_SNR = []
t_DR = []
t_grade = []
t_type = []
t_zqso = []
t_beta = []
t_imag = []
t_pfm = []
t_BAL = []
t_good = []
counter=0
pfm_unique = []
vi_files = glob.glob('vi_files/randsubset*MgII*.dat')

for vi_file in vi_files:
    for line in open(vi_file).readlines():
        if line.startswith('#')==0:
            cols = line.split()
            # plate-fiber-mjd  zqso imag zabs grade type MgII_ew1 MgIIewer1 MgII_ew2 MgII_ewer2 beta BAL1 BAL2 VI notes
            counter+=1
            #if float(cols[6])/(1.+float(cols[3]))>wlim and ('M' in str(cols[5]) or 'F' in str(cols[5])):
            if float(cols[6])/(1.+float(cols[3]))>wlim:
                t_fiber.append(int(str(cols[0]).split('-')[1]))
                t_zabs.append(float(cols[3]))
                t_W.append(float(cols[6])/(1.+float(cols[3])))
                t_Werr.append(float(cols[7])/(1.+float(cols[3])))
                t_SNR.append(float(cols[6])/float(cols[7]))
                t_DR.append(float(cols[6])/float(cols[8]))
                t_grade.append(lettonum_grade(str(cols[4])))
                t_type.append(lettonum_type(str(cols[5])))
                t_zqso.append(float(cols[1]))
                t_imag.append(float(cols[2]))
                t_beta.append(float(cols[10]))
                t_BAL.append(int(cols[11]))
                t_pfm.append(str(cols[0]))
                if str(cols[0]) not in pfm_unique:
                    pfm_unique.append(str(cols[0]))
                if str(cols[13])=='good':
                    t_good.append(1)
                #elif str(cols[13])=='bad':
                else:
                    t_good.append(0)
print "Size of training set: %i" % (len(t_good))
print "Fraction of repeats in training set: %.4f " % (float(counter-len(pfm_unique))/counter)
size_data = len(t_good)
X_train = []     
for m in range(0,size_data):
    newarr = []
    newarr.append(t_fiber[m])
    newarr.append(t_zabs[m])
    newarr.append(t_W[m])
    newarr.append(t_SNR[m])
    newarr.append(t_DR[m])
    newarr.append(t_grade[m])
    newarr.append(t_imag[m])
    newarr.append(t_type[m])
    newarr.append(t_zqso[m])
    newarr.append(t_beta[m])
    newarr.append(t_BAL[m])
    X_train.append(newarr)

Y = t_good[0:size_data]
feature_names = ['fiber', 'z_abs', 'MgII_W', 'MgII_SNR', 'DR', 'grade', 'imag', 'type', 'z_qso', 'beta', 'BAL']

'''
#
#  test set of overlapping Pitt & Chicago Mg II absorbers NOT included in training set
X_test2 = []
for m in range(0,len(t2_beta)):
    newarr = []
    newarr.append(t2_fiber[m])
    newarr.append(t2_zabs[m])
    newarr.append(t2_W[m])
    newarr.append(t2_W[m]/ta_Werr[m])
    newarr.append(t2_grade[m])
    #newarr.append(t2_type[m])
    newarr.append(t2_zqso[m])
    newarr.append(t2_beta[m])
    X_test2.append(newarr)

print " "
print "Training data of length: %i, %i" % (len(Y), len(X_train))
print "Test data of length: %i" % (len(X_test))
print " "
'''


# Initialize estimator
params = {'n_estimators': 10, 'max_depth': 10, 'criterion': 'entropy'}
estimator = RandomForestClassifier(**params)
#estimator = RandomForestClassifier(n_estimators=20, max_depth=20, criterion='entropy')

# Fit (train) model
estimator.fit(X_train, Y)


#X_test = X_test2
# Results
probs = estimator.predict_proba(X_test)
probs_dr7 = probs

#plot pairwise training set
fig = plotPairwiseClass(X_train, Y, labels=feature_names, s=2)
fig.savefig('pairwiseTrainingSet.png')

# cross-validation tests
Xtrain, Xtest, ytrain, ytest = train_test_split(np.array(X_train), np.array(Y), test_size=0.3, random_state=0)
estimator.fit(Xtrain, ytrain)
print "Correctness from cross-validation with 30 percent of sample: %0.4f" % (estimator.score(Xtest, ytest))
probs = estimator.predict_proba(Xtest)
X_test = Xtest
mse = mean_squared_error(ytest, estimator.predict(Xtest))
print("MSE: %.4f" % mse)

print " "
print 'N wrong (Training data): %i (%.4f)' % (np.sum(np.abs(Y-estimator.predict(X_train))), float(np.sum(np.abs(Y-estimator.predict(X_train))))/len(Y))
print " "


# Plot training deviance

# compute test set deviance
estimator_scores = []
estimators_number = []
for m in range(1,20):
    estscore = []
    for n in range(1,20):
        counter+=1
        params = {'n_estimators': m, 'max_depth': 10, 'criterion': 'entropy'}
        estimator = RandomForestClassifier(**params)
        Xtrain, Xtest, ytrain, ytest = train_test_split(np.array(X_train), np.array(Y), test_size=0.3, random_state=0)
        estimator.fit(Xtrain, ytrain)
        #print "Correctness from cross-validation with 30 percent of sample: %0.4f" % (estimator.score(Xtest, ytest))
        estscore.append(estimator.score(Xtest,ytest))
    estimator_scores.append(mean(estscore))
    estimators_number.append(m)

pl.clf()
pl.plot(estimators_number,estimator_scores)
pl.legend(loc='upper right')
pl.xlabel('Number of estimators')
pl.ylabel('Correctness')
pl.savefig('Training_estimators.png')

estimator_scores = []
estimators_number = []
for m in range(1,20):
    estscore = []
    for n in range(1,20):
        counter+=1
        params = {'n_estimators': 11, 'max_depth': m, 'criterion': 'entropy'}
        estimator = RandomForestClassifier(**params)
        Xtrain, Xtest, ytrain, ytest = train_test_split(np.array(X_train), np.array(Y), test_size=0.3, random_state=0)
        estimator.fit(Xtrain, ytrain)
        #print "Correctness from cross-validation with 30 percent of sample: %0.4f" % (estimator.score(Xtest, ytest))
        estscore.append(estimator.score(Xtest,ytest))
    estimator_scores.append(mean(estscore))
    estimators_number.append(m)

pl.clf()
pl.plot(estimators_number,estimator_scores)
pl.legend(loc='upper right')
pl.xlabel('Max Depth')
pl.ylabel('Correctness')
pl.savefig('Training_depth.png')

goodprobs = []
badprobs = []
train_probs = estimator.predict(X_train)
print train_probs[1:10]
for m in range(0,len(train_probs)):
    if Y[m]==0:
        badprobs.append(train_probs[m])
    elif Y[m]==1:
        goodprobs.append(train_probs[m])
        
bbins = []
binmin = 0.
binmax = 1.1
binnum = 10
binwidth=(binmax-binmin)/binnum
for m in range(0,binnum):
    bbins.append(binmin+m*binwidth)
        
# make plots of the probability of each system in the DR7, by grade
gradeAprobs = []
gradeBprobs = []
gradeCprobs = []
gradeCCprobs = []
gradeDprobs = []
gradeEprobs = []
fout = open('ml_visual_inspection.dat', 'w')
for m in range(0,len(X_test)):
    if X_test[m][5]==1:
        gradeAprobs.append(probs[m][1])
    elif X_test[m][5]==2:
        gradeBprobs.append(probs[m][1])
    elif X_test[m][5]==3:
        gradeCprobs.append(probs[m][1])
    elif X_test[m][5]==4:
        gradeCCprobs.append(probs[m][1])
    elif X_test[m][5]==5:
        gradeDprobs.append(probs[m][1])
    elif X_test[m][5]==6:
        gradeEprobs.append(probs[m][1])
    #print >> fout, "%20s %6.4f %3s %2i %4.1f %1i" % (ta_pfm[m], ta_zabs[m], numtolet_grade(ta_grade[m]), ta_vi[m], probs[m][1], good_flag[m])
    print >> fout, "%20s %6.4f %3s 1 %4.1f %1i" % (tt_pfm[m], X_test[m][1], numtolet_grade(X_test[m][5]), probs[m][1], ytest[m])

fout.close()


pl.clf()
if len(gradeAprobs)>0:
    pl.hist(gradeAprobs, bbins, histtype='step', normed='True', label='Grade A')
if len(gradeBprobs)>0:
    pl.hist(gradeBprobs, bbins, histtype='step', normed='True',label='Grade B')
if len(gradeCprobs)>0:
    pl.hist(gradeCprobs, bbins, histtype='step', normed='True',label='Grade C')
if len(gradeCCprobs)>0:
    pl.hist(gradeCCprobs, bbins, histtype='step', normed='True',label='Grade C*')
if len(gradeDprobs)>0:
    pl.hist(gradeDprobs, bbins, histtype='step', normed='True',label='Grade D')
if len(gradeEprobs)>0:
    pl.hist(gradeEprobs, bbins, histtype='step', normed='True',label='Grade E')
pl.legend(numpoints=1, loc = 'upper left')
pl.ylabel('Normalized Number')
pl.xlabel('Score')
pl.savefig('ml_probabilities_ChicagoOnly_MgII.png')


# print out fraction of detections above P(x)
Px=0.8
problists = [gradeAprobs, gradeBprobs, gradeCprobs, gradeCCprobs, gradeDprobs, gradeEprobs]
problabs = ['A', 'B', 'C', 'C*', 'D', 'E']
index=-1
for problist in problists:
    index+=1
    above=0.
    below=0.
    for m in problist:
        if m>=Px:
            above+=1.
        else:
            below+=1.
    if (above+below)>0:
        print "Fraction of Grade %s systems with P(x)>=%.1f: %.2f" % (problabs[index], Px, 100.*above/(above+below))
        
# Plot feature importance
feature_importance = estimator.feature_importances_
# make importances relative to max importance
feature_importance = 100.0 * (feature_importance / feature_importance.max())
sorted_idx = np.argsort(feature_importance)
print "Relative feature importance:"
newimportance = []
newnames = []
for m in sorted_idx:
    print "%s: %f" % (feature_names[m], feature_importance[m])
    newimportance.append(feature_importance[m])
    newnames.append(feature_names[m])
print " "
pos = np.arange(sorted_idx.shape[0]) + .5
pl.clf()
#pl.subplot(1, 2, 2)
pl.barh(pos, newimportance, align='center')
pl.yticks(pos, newnames)
pl.xlabel('Relative Importance')
pl.title('Variable Importance')
pl.savefig('variable_importance_MgII.png')


# calculate fraction of DR4 detections in our catalog, which are recovered by Pitt, as a function of grade
scores = []
grades = []
vi_class = []
for line in open('ml_visual_inspection.dat').readlines():
    cols =line.split()
    if str(cols[0])!='#':
        if int(cols[3])==1:
            scores.append(float(cols[4]))
            grades.append(str(cols[2]))
            vi_class.append(int(cols[5]))

poss_scores = np.linspace(0,1.,11)
print poss_scores

# calculate completeness & purity for each set of scores
completeness = []
contamination = []
totscores = []
purity = []
for m in range(0,len(poss_scores)):
    true_positives = 0.
    false_negatives = 0.
    false_positives = 0.
    for n in range(0,len(scores)):
        if scores[n]>=poss_scores[m]:
            if vi_class[n]==1:
                true_positives+=1
            else:
                false_positives+=1
        else:
            if vi_class[n]==1:
                false_negatives+=1
    completeness.append(true_positives/(true_positives+false_negatives))
    contamination.append(false_positives/(true_positives+false_positives))
    purity.append(1.-false_positives/(true_positives+false_positives))
    totscores.append(poss_scores[m])

pl.clf()
pl.plot(totscores, completeness, 'b-', label='completeness')
pl.plot(totscores, purity, 'r--', label='purity')
pl.xlabel('Score')
pl.legend(numpoints=1, loc='lower left')
pl.savefig('freelunch_contamination_MgII.png')

'''
# Calculate the score distribution for absorbers recovered by Pitt
dr4_pfm = []
for line in open('quider/unique_quider_qsos_inDR7.dat').readlines():
    dr4_pfm.append(cols[0])

pfm_pitt = []
zabs_pitt = []
for line in open('quider/MgII_absorber_catalog').readlines():
    cols = line.split()
    plate = int(cols[2])
    fiber = int(cols[3])
    mjd = int(cols[1])
    pfm_pitt.append(str(plate).zfill(4)+'-'+str(fiber).zfill(3)+'-'+str(mjd))
    zabs_pitt.append(float(cols[4]))

print " "
pitt_scores = []
overlap=0.
found_abovescore = []
for score in poss_scores:
    found_abovescore.append(0.)
    
allfound=0.
allfound_abovescore = 0.
for m in range(0,len(zabs_pitt)):
    for n in range(0,len(tt_pfm)):
            if pfm_pitt[m] == tt_pfm[n] and abs(zabs_pitt[m]-tt_zabs[n])<0.003:
                allfound+=1
                pitt_scores.append(probs_dr7[n][1])
                for k in range(0,len(poss_scores)):
                    if probs_dr7[n][1]>=poss_scores[k]:
                        found_abovescore[k]+=1.
for m in range(0,len(poss_scores)):
    print "Fraction of Pitt absorbers recovered with score >= %.1f: %0.3f" % (poss_scores[m], found_abovescore[m]/len(zabs_pitt))

pl.clf()
pl.hist(pitt_scores,bbins)
pl.xlabel('Score')
pl.savefig('Pittscores_matched.png')
'''
